import Combine
import Foundation
import SwiftDate
import Swinject
import UIKit

protocol FetchGlucoseManager: SourceInfoProvider {
    func updateGlucoseStore(newBloodGlucose: [BloodGlucose])
    func refreshCGM()
    func updateGlucoseSource()
    var glucoseSource: GlucoseSource! { get }
    var cgmGlucoseSourceType: CGMType? { get set }
    var settingsManager: SettingsManager! { get }
    var settings: FreeAPSSettings { get set }
    var preferences: Preferences { get }
}

final class BaseFetchGlucoseManager: FetchGlucoseManager, Injectable {
    private let processQueue = DispatchQueue(label: "BaseGlucoseManager.processQueue")
   /* @Injected() var tempTargetsStorage: TempTargetsStorage! */
    @Injected() var glucoseStorage: GlucoseStorage!
    @Injected() var nightscoutManager: NightscoutManager!
    @Injected() var apsManager: APSManager!
    @Injected() var settingsManager: SettingsManager!
    @Injected() var libreTransmitter: LibreTransmitterSource!
    @Injected() var healthKitManager: HealthKitManager!
    @Injected() var deviceDataManager: DeviceDataManager!
    @Injected() var broadcaster: Broadcaster!
    @Injected() var storage: FileStorage!
    @SyncAccess var settings: FreeAPSSettings {
        didSet {
            if oldValue != settings {
                save()
                DispatchQueue.main.async {
                    self.broadcaster.notify(SettingsObserver.self, on: .main) {
                        $0.settingsDidChange(self.settings)
                    }
                }
            }
        }
    }

    private var lifetime = Lifetime()
    private let timer = DispatchTimer(timeInterval: 1.minutes.timeInterval)
    var cgmGlucoseSourceType: CGMType?

    private lazy var dexcomSourceG5 = DexcomSourceG5(glucoseStorage: glucoseStorage, glucoseManager: self)
    private lazy var dexcomSourceG6 = DexcomSourceG6(glucoseStorage: glucoseStorage, glucoseManager: self)
    private lazy var dexcomSourceG7 = DexcomSourceG7(glucoseStorage: glucoseStorage, glucoseManager: self)
    private lazy var simulatorSource = GlucoseSimulatorSource()

    init(resolver: Resolver) {
        let storage = resolver.resolve(FileStorage.self)!
        settings = storage.retrieve(OpenAPS.FreeAPS.settings, as: FreeAPSSettings.self)
            ?? FreeAPSSettings(from: OpenAPS.defaults(for: OpenAPS.FreeAPS.settings))
            ?? FreeAPSSettings()
        injectServices(resolver)
        updateGlucoseSource()
        subscribe()
    }

    private func save() {
        storage.save(settings, as: OpenAPS.FreeAPS.settings)
    }

    var preferences: Preferences {
        storage.retrieve(OpenAPS.Settings.preferences, as: Preferences.self)
            ?? Preferences(from: OpenAPS.defaults(for: OpenAPS.Settings.preferences))
            ?? Preferences()
    }

    func processTempTargets() {
        let cd = CoreDataStorage()
        let tempTargetsArray = cd.fetchTempTargets()
        debug(.deviceManager, "Fetched \(tempTargetsArray.count) temp targets.")

        let tempTargetActive = tempTargetsArray.first?.active ?? false
        debug(.deviceManager, "Is first temp target active? \(tempTargetActive)")

        if tempTargetActive {
            let duration = Int(truncating: tempTargetsArray.first?.duration ?? 0)
            let startDate = tempTargetsArray.first?.startDate ?? Date()
            let durationPlusStart = startDate.addingTimeInterval(duration.minutes.timeInterval)
            let timeRemaining = durationPlusStart.timeIntervalSinceNow.minutes
            debug(
                .deviceManager,
                "Temp target duration: \(duration) minutes, Start date: \(startDate), Time remaining: \(timeRemaining) minutes"
            )

            if timeRemaining > 0.1 {
                // settingsManager.setLowCarbProfileEnabled(false)
                debug(
                    .deviceManager,
                    "No change back to default carb profile due to active Temp Target with \(timeRemaining) minutes remaining"
                )
            } else {
                settingsManager.setSleepModeEnabled(false)
                settingsManager.setLowCarbProfileEnabled(true)
                debug(.deviceManager, "Enabled Low Carb Profile and disabled Sleep Mode because Temp Target expired")
            }
        } else {
            settingsManager.setSleepModeEnabled(false)
            settingsManager.setLowCarbProfileEnabled(true)
            debug(.deviceManager, "Enabled Low Carb Profile and disabled Sleep Mode as no Temp Targets are active")
        }
    }

    var glucoseSource: GlucoseSource!

    func updateGlucoseSource() {
        switch settingsManager.settings.cgm {
        case .xdrip:
            glucoseSource = AppGroupSource(from: "xDrip", cgmType: .xdrip)
        case .dexcomG5:
            glucoseSource = dexcomSourceG5
        case .dexcomG6:
            glucoseSource = dexcomSourceG6
        case .dexcomG7:
            glucoseSource = dexcomSourceG7
        case .nightscout:
            glucoseSource = nightscoutManager
        case .simulator:
            glucoseSource = simulatorSource
        case .libreTransmitter:
            glucoseSource = libreTransmitter
        case .glucoseDirect:
            glucoseSource = AppGroupSource(from: "GlucoseDirect", cgmType: .glucoseDirect)
        case .enlite:
            glucoseSource = deviceDataManager
        }
        // update the config
        cgmGlucoseSourceType = settingsManager.settings.cgm

        if settingsManager.settings.cgm != .libreTransmitter {
            libreTransmitter.manager = nil
        } else {
            libreTransmitter.glucoseManager = self
        }
    }

    /// function called when a callback is fired by CGM BLE - no more used
    public func updateGlucoseStore(newBloodGlucose: [BloodGlucose]) {
        let syncDate = glucoseStorage.syncDate()
        debug(.deviceManager, "CGM BLE FETCHGLUCOSE  : SyncDate is \(syncDate)")
        glucoseStoreAndHeartDecision(syncDate: syncDate, glucose: newBloodGlucose)
        processTempTargets()
    }

    /// function to try to force the refresh of the CGM - generally provide by the pump heartbeat
    public func refreshCGM() {
        debug(.deviceManager, "refreshCGM by pump")
        updateGlucoseSource()
        Publishers.CombineLatest3(
            Just(glucoseStorage.syncDate()),
            healthKitManager.fetch(nil),
            glucoseSource.fetchIfNeeded()
        )
        .eraseToAnyPublisher()
        .receive(on: processQueue)
        .sink { syncDate, glucoseFromHealth, glucose in
            debug(.nightscout, "refreshCGM FETCHGLUCOSE : SyncDate is \(syncDate)")
            self.glucoseStoreAndHeartDecision(syncDate: syncDate, glucose: glucose, glucoseFromHealth: glucoseFromHealth)
        }
        .store(in: &lifetime)
        processTempTargets()
    }

    private func glucoseStoreAndHeartDecision(syncDate: Date, glucose: [BloodGlucose], glucoseFromHealth: [BloodGlucose] = []) {
        let allGlucose = glucose + glucoseFromHealth
        var filteredByDate: [BloodGlucose] = []
        var filtered: [BloodGlucose] = []

        // start background time extension
        var backGroundFetchBGTaskID: UIBackgroundTaskIdentifier?
        backGroundFetchBGTaskID = UIApplication.shared.beginBackgroundTask(withName: "save BG starting") {
            guard let bg = backGroundFetchBGTaskID else { return }
            UIApplication.shared.endBackgroundTask(bg)
            backGroundFetchBGTaskID = .invalid
        }

        guard allGlucose.isNotEmpty else {
            if let backgroundTask = backGroundFetchBGTaskID {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backGroundFetchBGTaskID = .invalid
            }
            return
        }

        filteredByDate = allGlucose.filter { $0.dateString > syncDate }
        filtered = glucoseStorage.filterTooFrequentGlucose(filteredByDate, at: syncDate)

        guard filtered.isNotEmpty else {
            // end of the BG tasks
            if let backgroundTask = backGroundFetchBGTaskID {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backGroundFetchBGTaskID = .invalid
            }
            return
        }
        debug(.deviceManager, "New glucose found")

        // filter the data if it is the case
        if settingsManager.settings.smoothGlucose {
            // limit to 30 minutes of previous BG Data
            let oldGlucoses = glucoseStorage.recent().filter {
                $0.dateString.addingTimeInterval(31 * 60) > Date()
            }
            var smoothedValues = oldGlucoses + filtered
            // smooth with 3 repeats
            for _ in 1 ... 3 {
                smoothedValues.smoothSavitzkyGolayQuaDratic(withFilterWidth: 3)
            }
            // find the new values only
            filtered = smoothedValues.filter { $0.dateString > syncDate }
        }

        glucoseStorage.storeGlucose(filtered)

        deviceDataManager.heartbeat(date: Date())

        nightscoutManager.uploadGlucose()

        // end of the BG tasks
        if let backgroundTask = backGroundFetchBGTaskID {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backGroundFetchBGTaskID = .invalid
        }

        let glucoseForHealth = filteredByDate.filter { !glucoseFromHealth.contains($0) }
        guard glucoseForHealth.isNotEmpty else {
            return
        }
        healthKitManager.saveIfNeeded(bloodGlucose: glucoseForHealth)

        processTempTargets()
    }

    /// The function used to start the timer sync - Function of the variable defined in config
    private func subscribe() {
        timer.publisher
            .receive(on: processQueue)
            .flatMap { _ -> AnyPublisher<[BloodGlucose], Never> in
                debug(.nightscout, "FetchGlucoseManager timer heartbeat")
                self.updateGlucoseSource()
                return self.glucoseSource.fetch(self.timer).eraseToAnyPublisher()
            }
            .sink { glucose in
                debug(.nightscout, "FetchGlucoseManager callback sensor")
                Publishers.CombineLatest3(
                    Just(glucose),
                    Just(self.glucoseStorage.syncDate()),
                    self.healthKitManager.fetch(nil)
                )
                .eraseToAnyPublisher()
                .sink { newGlucose, syncDate, glucoseFromHealth in
                    self.glucoseStoreAndHeartDecision(
                        syncDate: syncDate,
                        glucose: newGlucose,
                        glucoseFromHealth: glucoseFromHealth
                    )
                }
                .store(in: &self.lifetime)
            }
            .store(in: &lifetime)
        timer.fire()
        timer.resume()

        UserDefaults.standard
            .publisher(for: \.dexcomTransmitterID)
            .removeDuplicates()
            .sink { id in
                if self.settingsManager.settings.cgm == .dexcomG5 {
                    if id != self.dexcomSourceG5.transmitterID {
                        self.dexcomSourceG5 = DexcomSourceG5(glucoseStorage: self.glucoseStorage, glucoseManager: self)
                    }
                } else if self.settingsManager.settings.cgm == .dexcomG6 {
                    if id != self.dexcomSourceG6.transmitterID {
                        self.dexcomSourceG6 = DexcomSourceG6(glucoseStorage: self.glucoseStorage, glucoseManager: self)
                    }
                }
            }
            .store(in: &lifetime)
    }

    func sourceInfo() -> [String: Any]? {
        glucoseSource.sourceInfo()
    }
}

extension UserDefaults {
    @objc var dexcomTransmitterID: String? {
        get {
            string(forKey: "DexcomSource.transmitterID")?.nonEmpty
        }
        set {
            set(newValue, forKey: "DexcomSource.transmitterID")
        }
    }
}
