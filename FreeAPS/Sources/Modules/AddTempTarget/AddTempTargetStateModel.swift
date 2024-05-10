import CoreData
import SwiftUI

extension AddTempTarget {
    final class StateModel: BaseStateModel<Provider> {
        @Injected() private var storage: TempTargetsStorage!
        @Injected() var apsManager: APSManager!

        let coredataContext = CoreDataStack.shared.persistentContainer.viewContext

        @Published var low: Decimal = 0
        // @Published var target: Decimal = 0
        @Published var high: Decimal = 0
        @Published var duration: Decimal = 0
        @Published var duration2: Decimal = 0
        @Published var date = Date()
        @Published var newPresetName = ""
        @Published var presets: [TempTarget] = []
        @Published var percentage = 100.0
        @Published var maxValue: Decimal = 1.2
        @Published var maxValueAS: Decimal = 1.2
        @Published var use_autoISF = false
        @Published var viewPercantage = false
        @Published var hbt: Double = 160
        @Published var saveSettings: Bool = false
        @Published var carbProfileSelection: String = "Low"
        @Published var tempLowCarbProfileEnabled: Bool = false
        @Published var tempMediumCarbProfileEnabled: Bool = false
        @Published var tempHighCarbProfileEnabled: Bool = false
        @Published var lowCarbProfile: Bool = false
        @Published var mediumCarbProfile: Bool = false
        @Published var highCarbProfile: Bool = false

        private(set) var units: GlucoseUnits = .mmolL

        override func subscribe() {
            units = settingsManager.settings.units
            presets = storage.presets()
            maxValue = settingsManager.preferences.autosensMax
            maxValueAS = settingsManager.preferences.autoISFmax
            use_autoISF = settingsManager.preferences.autoisf
        }

        func applyCarbProfileSetting() {
            switch carbProfileSelection {
            case "Low":
                settingsManager.setLowCarbProfileEnabled(true)
            case "Medium":
                settingsManager.setMediumCarbProfileEnabled(true)
            case "High":
                settingsManager.setHighCarbProfileEnabled(true)
            default:
                break
            }
        }

        func enact() {
            guard duration > 0 else {
                return
            }
            if carbProfileSelection == "Low" {
                settingsManager.setLowCarbProfileEnabled(true)
                lowCarbProfile = true
                mediumCarbProfile = false
                highCarbProfile = false
            }
            if carbProfileSelection == "Medium" {
                settingsManager.setMediumCarbProfileEnabled(true)
                lowCarbProfile = false
                mediumCarbProfile = true
                highCarbProfile = false
            }
            if carbProfileSelection == "High" {
                settingsManager.setHighCarbProfileEnabled(true)
                lowCarbProfile = false
                mediumCarbProfile = false
                highCarbProfile = true
            }

            var lowTarget = low
            if units == .mmolL {
                lowTarget = Decimal(round(Double(lowTarget.asMgdL)))
            }
            let highTarget = lowTarget

            if !viewPercantage {
//                hbt = computeHBT()
//                coredataContext.performAndWait {
//                    let saveToCoreData = TempTargets(context: self.coredataContext)
//                    saveToCoreData.id = UUID().uuidString
//                    saveToCoreData.active = true
//                    saveToCoreData.hbt = hbt
//                    saveToCoreData.date = Date()
//                    saveToCoreData.duration = duration as NSDecimalNumber
//                    saveToCoreData.startDate = Date()
//                    try? self.coredataContext.save()
//                }
//                saveSettings = true
//            } else {
                coredataContext.performAndWait {
                    let saveToCoreData = TempTargets(context: coredataContext)
                    saveToCoreData.active = true
                    saveToCoreData.date = Date()
                    saveToCoreData.duration = duration as NSDecimalNumber
                    saveToCoreData.startDate = Date()
                    saveToCoreData.low = low as NSDecimalNumber
                    saveToCoreData.lowCarbProfile = lowCarbProfile
                    saveToCoreData.mediumCarbProfile = mediumCarbProfile
                    saveToCoreData.highCarbProfile = highCarbProfile
                    try? coredataContext.save()
                }
            }

            let entry = TempTarget(
                name: TempTarget.custom,
                createdAt: date,
                targetTop: highTarget,
                targetBottom: lowTarget,
                duration: duration,
                enteredBy: TempTarget.manual,
                reason: TempTarget.custom,
                lowCarbProfile: lowCarbProfile,
                mediumCarbProfile: mediumCarbProfile,
                highCarbProfile: highCarbProfile
            )
            storage.storeTempTargets([entry])
            showModal(for: nil)
        }

        func cancel() {
            storage.storeTempTargets([TempTarget.cancel(at: Date())])
            showModal(for: nil)

            settingsManager.setLowCarbProfileEnabled(true)
            lowCarbProfile = true
            mediumCarbProfile = false
            highCarbProfile = false

            coredataContext.performAndWait {
                let saveToCoreData = TempTargets(context: self.coredataContext)
                saveToCoreData.active = false
                saveToCoreData.date = Date()
                saveToCoreData.lowCarbProfile = lowCarbProfile
                saveToCoreData.mediumCarbProfile = mediumCarbProfile
                saveToCoreData.highCarbProfile = highCarbProfile
                try? self.coredataContext.save()

//                let setHBT = TempTargetsSlider(context: self.coredataContext)
//                setHBT.enabled = false
//                setHBT.date = Date()
//                try? self.coredataContext.save()
            }
        }

        func save() {
            guard duration > 0 else {
                return
            }
            var lowTarget = low
            if units == .mmolL {
                lowTarget = Decimal(round(Double(lowTarget.asMgdL)))
            }
            let highTarget = lowTarget

            if carbProfileSelection == "Low" {
                lowCarbProfile = true
                mediumCarbProfile = false
                highCarbProfile = false
            }
            if carbProfileSelection == "Medium" {
                lowCarbProfile = false
                mediumCarbProfile = true
                highCarbProfile = false
            }
            if carbProfileSelection == "High" {
                lowCarbProfile = false
                mediumCarbProfile = false
                highCarbProfile = true
            }

//            if viewPercantage {
//                hbt = computeHBT()
//                saveSettings = true
//            }

            let entry = TempTarget(
                name: newPresetName.isEmpty ? TempTarget.custom : newPresetName,
                createdAt: Date(),
                targetTop: highTarget,
                targetBottom: lowTarget,
                duration: duration,
                enteredBy: TempTarget.manual,
                reason: newPresetName.isEmpty ? TempTarget.custom : newPresetName,
                lowCarbProfile: lowCarbProfile,
                mediumCarbProfile: mediumCarbProfile,
                highCarbProfile: highCarbProfile
            )
            presets.append(entry)
            storage.storePresets(presets)

            if !viewPercantage {
//                let id = entry.id

//                coredataContext.performAndWait {
//                    let saveToCoreData = TempTargetsSlider(context: self.coredataContext)
//                    saveToCoreData.id = id
//                    saveToCoreData.isPreset = true
//                    saveToCoreData.enabled = true
//                    saveToCoreData.hbt = hbt
//                    saveToCoreData.date = Date()
//                    saveToCoreData.duration = duration as NSDecimalNumber
//                    try? self.coredataContext.save()
//                }
//            } else {
                let id = entry.id

                coredataContext.performAndWait {
                    let saveToCoreData = TempTargets(context: coredataContext)
                    saveToCoreData.id = id
                    saveToCoreData.isPreset = true
                    saveToCoreData.enabled = true
                    saveToCoreData.date = Date()
                    saveToCoreData.duration = duration as NSDecimalNumber
                    saveToCoreData.low = low as NSDecimalNumber
                    saveToCoreData.lowCarbProfile = lowCarbProfile
                    saveToCoreData.mediumCarbProfile = mediumCarbProfile
                    saveToCoreData.highCarbProfile = highCarbProfile
                    try? coredataContext.save()
                }
            }
        }

        func enactPreset(id: String) {
            if var preset = presets.first(where: { $0.id == id }) {
                preset.createdAt = Date()
                storage.storeTempTargets([preset])
                showModal(for: nil)

                settingsManager.setLowCarbProfileEnabled(preset.lowCarbProfile ?? true)
                settingsManager.setMediumCarbProfileEnabled(preset.mediumCarbProfile ?? false)
                settingsManager.setHighCarbProfileEnabled(preset.highCarbProfile ?? false)

                coredataContext.performAndWait {
                    var tempTargetsArray = [TempTargets]()
                    let requestTempTargets = TempTargets.fetchRequest() as NSFetchRequest<TempTargets>
                    let sortTT = NSSortDescriptor(key: "date", ascending: false)
                    requestTempTargets.sortDescriptors = [sortTT]
                    try? tempTargetsArray = coredataContext.fetch(requestTempTargets)

                    let whichID = tempTargetsArray.first(where: { $0.id == id })

                    if whichID != nil {
                        let saveToCoreData = TempTargets(context: self.coredataContext)
                        saveToCoreData.active = true
                        saveToCoreData.date = Date()
                        // saveToCoreData.hbt = whichID?.hbt ?? 160
                        // saveToCoreData.id = id
                        saveToCoreData.startDate = Date()
                        saveToCoreData.duration = whichID?.duration ?? 0
                        saveToCoreData.low = low as NSDecimalNumber
                        saveToCoreData.lowCarbProfile = preset.lowCarbProfile ?? true
                        saveToCoreData.mediumCarbProfile = preset.mediumCarbProfile ?? false
                        saveToCoreData.highCarbProfile = preset.highCarbProfile ?? false

                        try? self.coredataContext.save()
                    }
                }
            }
        }

        func removePreset(id: String) {
            presets = presets.filter { $0.id != id }
            storage.storePresets(presets)
        }

//        func computeHBT() -> Double {
//            let ratio = Decimal(percentage / 100)
//            let normalTarget: Decimal = 100
//            var target: Decimal = low
//            if units == .mmolL {
//                target = target.asMgdL }
//            var hbtcalc = Decimal(hbt)
//            if ratio != 1 {
//                hbtcalc = ((2 * ratio * normalTarget) - normalTarget - (ratio * target)) / (ratio - 1)
//            }
//            return round(Double(hbtcalc))
//        }
    }
}
