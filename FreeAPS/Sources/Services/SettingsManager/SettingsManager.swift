import Foundation
import LoopKit
import Swinject

protocol SettingsManager: AnyObject {
    var settings: FreeAPSSettings { get set }
    var preferences: Preferences { get }
    var pumpSettings: PumpSettings { get }
    func updateInsulinCurve(_ insulinType: InsulinType?)
    func setSleepModeEnabled(_ isEnabled: Bool)
    func setHighCarbProfileEnabled(_ isEnabled: Bool)
    func setMediumCarbProfileEnabled(_ isEnabled: Bool)
    func setLowCarbProfileEnabled(_ isEnabled: Bool)
}

protocol SettingsObserver {
    func settingsDidChange(_: FreeAPSSettings)
}

final class BaseSettingsManager: SettingsManager, Injectable {
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

    init(resolver: Resolver) {
        let storage = resolver.resolve(FileStorage.self)!
        settings = storage.retrieve(OpenAPS.FreeAPS.settings, as: FreeAPSSettings.self)
            ?? FreeAPSSettings(from: OpenAPS.defaults(for: OpenAPS.FreeAPS.settings))
            ?? FreeAPSSettings()

        injectServices(resolver)
    }

    private func save() {
        storage.save(settings, as: OpenAPS.FreeAPS.settings)
    }

    var preferences: Preferences {
        storage.retrieve(OpenAPS.Settings.preferences, as: Preferences.self)
            ?? Preferences(from: OpenAPS.defaults(for: OpenAPS.Settings.preferences))
            ?? Preferences()
    }

    var pumpSettings: PumpSettings {
        storage.retrieve(OpenAPS.Settings.settings, as: PumpSettings.self)
            ?? PumpSettings(from: OpenAPS.defaults(for: OpenAPS.Settings.settings))
            ?? PumpSettings(insulinActionCurve: 6, maxBolus: 10, maxBasal: 2)
    }

    func updateInsulinCurve(_ insulinType: InsulinType?) {
        var prefs = preferences

        switch insulinType {
        case .apidra,
             .humalog,
             .novolog:
            prefs.curve = .rapidActing

        case .fiasp,
             .lyumjev:
            prefs.curve = .ultraRapid
        default:
            prefs.curve = .rapidActing
        }
        storage.save(prefs, as: OpenAPS.Settings.preferences)
    }
    
    func setSleepModeEnabled(_ isEnabled: Bool) {
        var prefs = preferences

        prefs.sleepMode = isEnabled

        // Save the updated preferences back to storage
        storage.save(prefs, as: OpenAPS.Settings.preferences)
        print("Sleep Mode set to: \(isEnabled)")
    }

    func setHighCarbProfileEnabled(_ isEnabled: Bool) {
        var prefs = preferences // Retrieve the current preferences

        // Set the high carb profile as per the isEnabled flag
        prefs.highCarbezFCLProfile = isEnabled

        // If the high carb profile is enabled, disable the other profiles
        if isEnabled {
            prefs.lowCarbezFCLProfile = false
            prefs.moderateCarbezFCLProfile = false
        }

        // Save the updated preferences back to storage
        storage.save(prefs, as: OpenAPS.Settings.preferences)
        print("High Carb Profile set to: \(isEnabled)")
    }

    func setMediumCarbProfileEnabled(_ isEnabled: Bool) {
        var prefs = preferences // Retrieve the current preferences

        // Set the low carb profile as per the isEnabled flag
        prefs.moderateCarbezFCLProfile = isEnabled

        // If the high carb profile is enabled, disable the other profiles
        if isEnabled {
            prefs.highCarbezFCLProfile = false
            prefs.lowCarbezFCLProfile = false
        }

        // Save the updated preferences back to storage
        storage.save(prefs, as: OpenAPS.Settings.preferences)
        print("Medium Carb Profile set to: \(isEnabled)")
    }

    func setLowCarbProfileEnabled(_ isEnabled: Bool) {
        var prefs = preferences // Retrieve the current preferences

        // Set the low carb profile as per the isEnabled flag
        prefs.lowCarbezFCLProfile = isEnabled

        // If the high carb profile is enabled, disable the other profiles
        if isEnabled {
            prefs.highCarbezFCLProfile = false
            prefs.moderateCarbezFCLProfile = false
        }

        // Save the updated preferences back to storage
        storage.save(prefs, as: OpenAPS.Settings.preferences)
        print("Low Carb Profile set to: \(isEnabled)")
    }
}
