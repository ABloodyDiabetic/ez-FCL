import Foundation
import SwiftUI

extension PreferencesEditor {
    final class StateModel: BaseStateModel<Provider>, PreferencesSettable {
        private(set) var preferences = Preferences()
        @Published var unitsIndex = 1
        @Published var allowAnnouncements = false
        @Published var skipBolusScreenAfterCarbs = false
        @Published var sections: [FieldSection] = []
        @Published var useAlternativeBolusCalc: Bool = false
        @Published var units: GlucoseUnits = .mmolL

        override func subscribe() {
            preferences = provider.preferences
            units = settingsManager.settings.units

            subscribeSetting(\.units, on: $unitsIndex.map { $0 == 0 ? GlucoseUnits.mgdL : .mmolL }) {
                unitsIndex = $0 == .mgdL ? 0 : 1
            } didSet: { [weak self] _ in
                self?.provider.migrateUnits()
            }

//            let firstSMBToggle = [
//                Field(
//                    displayName: NSLocalizedString("Enable SMB", comment: "Enable SMB"),
//                    type: .boolean(keypath: \.enableSMBAlways),
//                    infoText: NSLocalizedString(
//                        "Defaults to false. When true, always enable supermicrobolus (unless disabled by high temptarget).",
//                        comment: "Enable SMB"
//                    ),
//                    settable: self
//                )
//            ]

            let glucoseFields = [
//                Field(
//                    displayName: "Flat Glucose Check",
//                    type: .boolean(keypath: \.flatGlucoseCheck),
//                    infoText: "Defaults to true. When true, if glucose values are too flat, ezFCL does not loop and eventually reverts back to the profile basal if glucose readings are flat for too long. When false, flat glucose values will not trigger the cessation of loops. You should set this to false when you are using a software calibrated CGM or when you are using a Calibration Slope and Intercept value other than 1 and 0 respectively. This helps to mitigate the risk of going low when a sensor's minimum glucose value boundary has been elevated due to software based calibration. Example: if the lowest value your software calibrated sensor will read is 90 (after calibration), and your glucose gets pegged at that value (because your actual glucose value is still falling), ezFCL will continue to assume that your glucose is trending down, and will maintain a 0 temp basal until the glucose level rises back above 90. You may need to restart the app for the change to apply.",
//                    settable: self
//                ),
                Field(
                    displayName: "NS Glucose Calibration Slope",
                    type: .decimal(keypath: \.glucoseCalibrationSlope),
                    infoText: "1 = No Change. The slope value used to calibrate glucose readings. For use with Nightscout as a glucose source with glucose values brodcast from xDrip or similar app which provides Slope and Intercept values based on it's calibration but doesn't send calibrated values over to NS. You must restart the app for changes to apply. It is suggested to set a Temp Basal Rate with an odd target so that SMBs are disabled to protect against overdelivery from a calibration spike.",
                    settable: self
                ),
                Field(
                    displayName: "NS Glucose Calibration Intercept",
                    type: .decimal(keypath: \.glucoseCalibrationIntercept),
                    infoText: "0 = No Change. The intercept value used to calibrate glucose readings. Negative values must be entered into the preferences.json. For use with Nightscout as a glucose source with glucose values brodcast from xDrip or similar app which provides Slope and Intercept values based on it's calibration but doesn't send calibrated values over to NS. You must restart the app for changes to apply. It is suggested to set a Temp Basal Rate with an odd target so that SMBs are disabled to protect against overdelivery from a calibration spike.",
                    settable: self
                )
            ]

            let quickPrefs = [
                Field(
                    displayName: NSLocalizedString("Enable MBs", comment: "Enable MBs"),
                    type: .boolean(keypath: \.enableSMBAlways),
                    infoText: NSLocalizedString(
                        "Defaults to false. When true, enables microboluses (unless disabled by high temptarget).",
                        comment: "Enable MBs"
                    ),
                    settable: self
                ),
//                Field(
//                    displayName: "Enable SMBs over this BG" + " (mg/dL)",
//                    type: .decimal(keypath: \.enableSMB_high_bg_target),
//                    infoText: NSLocalizedString(
//                        "The Value above which Enable SMBs With High BG will switch on SMB's. If you want no SMB's below that value Enable SMB Always needs to be off.",
//                        comment: "Over This BG (mg/dl):"
//                    ),
//                    settable: self
//                ),
                Field(
                    displayName: "Enable Max IOB Deadbands",
                    type: .boolean(keypath: \.enableMaxIobDeadbands),
                    infoText: NSLocalizedString(
                        "Enable Max IOB Deadbands",
                        comment: "Enable Max IOB Deadbands"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Enable Sleep Mode",
                    type: .boolean(keypath: \.sleepMode),
                    infoText: NSLocalizedString(
                        "Defaults to false. When true, the 'Max IOB %' is set to equal the 'Max IOB Loose Deadband %'. This must manually be toggled on or off to enable or disable Sleep Mode manually when 'Sleep Detection' is disabled or when Apple Health is not capable of determing sleep state.",
                        comment: "Sleep Mode"
                    ),
                    settable: self
                ),
               /* Field(
                    displayName: "Sleep Detection (Enable Sleep Mode Automatically)",
                    type: .boolean(keypath: \.automaticSleepMode),
                    infoText: NSLocalizedString(
                        "Defaults to false. When true, the 'Max IOB %' is set to equal the 'Max IOB Loose Deadband %' automatically whenever you are asleep by scrutinizing Apple Health sleep data to determine sleep state vs awake.",
                        comment: "Enable Sleep Mode Automatically"
                    ),
                    settable: self
                ), */
                Field(
                    displayName: "Exercise Mode",
                    type: .boolean(keypath: \.exerciseMode),
                    infoText: NSLocalizedString(
                        "Defaults to false. When true, > 100 mg/dL high temp target adjusts sensitivityRatio for exercise mode. Synonym for high_temptarget_raises_sensitivity",
                        comment: "Exercise Mode"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Half Basal Exercise Target", comment: "Half Basal Exercise Target") +
                        " (mg/dL)",
                    type: .decimal(keypath: \.halfBasalExerciseTarget),
                    infoText: NSLocalizedString(
                        "Set to a number in mg/dl, e.g. 160, which means when TempTarget (TT) is 160 mg/dL and exercise mode = true, it will run 50% basal at this TT level (if high TT at 120 = 75%; 140 = 60%). This can be adjusted, to give you more control over your exercise modes.",
                        comment: "Half Basal Exercise Target"
                    ),
                    settable: self
                )
            ]

            let tddFields = [
                Field(
                        displayName: "Initial 24 Hour TDD",
                        type: .decimal(keypath: \.twentyFourHrTDDPlaceholder),
                        infoText: NSLocalizedString(
                            "Initial 24 Hour TDD",
                            comment: "Initial 24 Hour TDD"
                        ),
                        settable: self
                    ),
                Field(
                        displayName: "Initial 7 Day TDD",
                        type: .decimal(keypath: \.sevenDayTDDPlaceholder),
                        infoText: NSLocalizedString(
                            "Initial 7 Day TDD",
                            comment: "Initial 7 Day TDD"
                        ),
                        settable: self
                    ),
               /* Field(
                    displayName: "TDD ISF Adjustment Factor",
                    type: .decimal(keypath: \.calculateIsfFromTddNumeratorDivisor),
                    infoText: NSLocalizedString(
                        "Defaults to 0.5. A value of 0.5 increases the calculated TDD ISF by 50% (numerator adjusted from 1700 to 3400), reducing recommended dosings by 50% and basal rate by 50%. You should continue to nudge this value up overtime from 0.5 until your average BG is at or very near your target glucose. If you are getting roller coaster blood glucose values, either this value is too high or the profile basal and ISF need to be adjusted. Having a well tuned initial profile basal and profile ISF is probably the important factor when configuring ezFCL. TDD ISF = 1700 / TDD ISF Adjustment / TDD",
                        comment: "Calculate ISF From TDD Numerator Divisor"
                    ),
                    settable: self
                ), */
               /* Field(
                    displayName: "Basal Multiplier",
                    type: .decimal(keypath: \.basalMultiplier),
                    infoText: NSLocalizedString(
                        "Increase or decrese basal rates relative to the TDD ISF to improve alignment.",
                        comment: "Basal Multiplier"
                    ),
                    settable: self
                ), */
                Field(
                    displayName: "ISF Slope",
                    type: .decimal(keypath: \.isfSlope),
                    infoText: NSLocalizedString(
                        "Increase or decrese ISF rates relative to a slope value.",
                        comment: "ISF Slope"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "ISF Intercept",
                    type: .decimal(keypath: \.isfIntercept),
                    infoText: NSLocalizedString(
                        "Increase or decrese ISF rates relative to an intercept value.",
                        comment: "ISF Intercept"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Basal Slope",
                    type: .decimal(keypath: \.basalSlope),
                    infoText: NSLocalizedString(
                        "Increase or decrese basal rates relative to a slope value.",
                        comment: "Basal Slope"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Basal Intercept",
                    type: .decimal(keypath: \.basalIntercept),
                    infoText: NSLocalizedString(
                        "Increase or decrese basal rates relative to an intercept value.",
                        comment: "Basal Intercept"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Use TDD ISF to Calculate Sensitivity and Basal Rate",
                    type: .boolean(keypath: \.useAutosensIsfToCalculateAutoIsfSens),
                    infoText: "Defaults to true. When true, the TDD ISF is used to calculate Sensitivity and Basal Rates instead of using the profile ISF. The hypothesis is that this makes ezFCL far more adaptable to large swings in sensitivity that take place over several hours or days. This should make transitioning back and forth between fasting and gorging much easier by taking away some of the cognitive load required to manually adjust sensitivity settings up or down with a dynamic lifestyle.This also adjusts the ‘Max Daily Safety Multiplier’ and the ‘Current Basal Safety Multiplier’ up or down as necessary relative to the TDD ISF.",
                    settable: self
                )
//                Field(
//                    displayName: "Adjust Basal Relative to TDD ISF",
//                    type: .boolean(keypath: \.adjustBasalInverselyToAutosensIsf),
//                    infoText: "Defaults to false. When true, this assumes a direct relationship between one’s current TDD and one’s required basal rate. This adjusts the basal rate up or down relative to your TDD and calculates the ‘Max Daily Safety Multiplier’ and the ‘Current Basal Safety Multiplier’ using the adjusted basal rate instead of the profile basal rate.",
//                    settable: self
//                )
            ]

            let mainFields = [
                Field(
                    displayName: NSLocalizedString("Max IOB %", comment: "Max IOB %"),
                    type: .decimal(keypath: \.maxIOB),
                    infoText: NSLocalizedString(
                        "Max IOB is the maximum amount of insulin on board from all sources – both basal (or MB correction) and bolus insulin – that your loop is allowed to accumulate to treat higher-than-target BG. max_iob is set as a percentage of the TDD to allow dynamic adjustment. As of now, manual boluses are NOT limited by this setting. \n\n To test your basal rates during nighttime, you can modify the Max IOB setting to zero while in Closed Loop. This will enable low glucose suspend mode while testing your basal rates settings.",
                        comment: "Max IOB %"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Max IOB Tight Deadband %",
                    type: .decimal(keypath: \.maxIobTightDeadband),
                    infoText: NSLocalizedString(
                        "Tight Deadband",
                        comment: "Max IOB Tight Deadband %"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Max IOB Loose Deadband %",
                    type: .decimal(keypath: \.maxIobLooseDeadband),
                    infoText: NSLocalizedString(
                        "Loose Deadband",
                        comment: "Max IOB Loose Deadband %"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Tight Deadband Range",
                    type: .decimal(keypath: \.tightDeadbandRange),
                    infoText: NSLocalizedString(
                        "Tight Deadband Range",
                        comment: "Tight Deadband Range"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Loose Deadband Range",
                    type: .decimal(keypath: \.looseDeadbandRange),
                    infoText: NSLocalizedString(
                        "Loose Deadband Range",
                        comment: "Loose Deadband Range"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Insulin curve", comment: "Insulin curve"),
                    type: .insulinCurve(keypath: \.curve),
                    infoText: "Insulin curve info",
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Use Custom Peak Time", comment: "Use Custom Peak Time"),
                    type: .boolean(keypath: \.useCustomPeakTime),
                    infoText: NSLocalizedString(
                        "Defaults to true. Setting to true allows changing insulinPeakTime", comment: "Use Custom Peak Time"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Insulin Peak Time", comment: "Insulin Peak Time"),
                    type: .decimal(keypath: \.insulinPeakTime),
                    infoText: NSLocalizedString(
                        "Time of maximum blood glucose lowering effect of insulin, in minutes. Beware: Oref assumes for ultra-rapid (Lyumjev) & rapid-acting (Fiasp) curves minimal (35 & 50 min) and maximal (100 & 120 min) applicable insulinPeakTimes. Using a custom insulinPeakTime outside these bounds will result in issues with ezFCL, longer loop calculations and possible red loops.",
                        comment: "Insulin Peak Time"
                    ),
                    settable: self
                ),
//                Field(
//                    displayName: NSLocalizedString("Max COB", comment: "Max COB"),
//                    type: .decimal(keypath: \.maxCOB),
//                    infoText: NSLocalizedString(
//                        "The default of maxCOB is 120. (If someone enters more carbs in one or multiple entries, ezFCL will cap COB to maxCOB and keep it at maxCOB until the carbs entered above maxCOB have shown to be absorbed. Essentially, this just limits UAM as a safety cap against weird COB calculations due to fluky data.)",
//                        comment: "Max COB"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: "Enable Floating Carbs",
//                    type: .boolean(keypath: \.floatingcarbs),
//                    infoText: NSLocalizedString(
//                        "Defaults to false. If true, then dose slightly more aggressively by using all entered carbs for calculating COBpredBGs. This avoids backing off too quickly as COB decays. Even with this option, oref0 still switches gradually from using COBpredBGs to UAMpredBGs proportionally to how many carbs are left as COB. Summary: use all entered carbs in the future for predBGs & don't decay them as COB, only once they are actual.",
//                        comment: "Floating Carbs"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Max Daily Safety Multiplier", comment: "Max Daily Safety Multiplier"),
//                    type: .decimal(keypath: \.maxDailySafetyMultiplier),
//                    infoText: NSLocalizedString(
//                        "This is an important OpenAPS safety limit. The default setting (which is unlikely to need adjusting) is 3. This means that OpenAPS will never be allowed to set a temporary basal rate that is more than 3x the highest hourly basal rate programmed in a user’s pump, or, if enabled, determined by TDD Adjustment Factor.",
//                        comment: "Max Daily Safety Multiplier"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Current Basal Safety Multiplier", comment: "Current Basal Safety Multiplier"),
//                    type: .decimal(keypath: \.currentBasalSafetyMultiplier),
//                    infoText: NSLocalizedString(
//                        "This is another important OpenAPS safety limit. The default setting (which is also unlikely to need adjusting) is 4. This means that OpenAPS will never be allowed to set a temporary basal rate that is more than 4x the current hourly basal rate programmed in a user’s pump, or, if enabled, determined by TDD Adjustment Factor.",
//                        comment: "Current Basal Safety Multiplier"
//                    ),
//                    settable: self
//                )
                Field(
                    displayName: NSLocalizedString("Enable Autosens", comment: "Enable Autosens"),
                    type: .boolean(keypath: \.enableAutosens),
                    infoText: NSLocalizedString(
                        "Switch Autosens on/off",
                        comment: "Autosens"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Autosens Max", comment: "Autosens Max"),
                    type: .decimal(keypath: \.autosensMax),
                    infoText: NSLocalizedString(
                        "This is a multiplier cap for autosens (and autotune) to set a 20% max limit on how high the autosens ratio can be, which in turn determines how high autosens can adjust basals, how low it can adjust ISF, and how low it can set the BG target.",
                        comment: "Autosens Max"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Autosens Min", comment: "Autosens Min"),
                    type: .decimal(keypath: \.autosensMin),
                    infoText: NSLocalizedString(
                        "The other side of the autosens safety limits, putting a cap on how low autosens can adjust basals, and how high it can adjust ISF and BG targets.",
                        comment: "Autosens Min"
                    ),
                    settable: self
                )
            ]

            let smbFields = [
                //                Field(
//                    displayName: NSLocalizedString("Enable SMB", comment: "Enable SMB"),
//                    type: .boolean(keypath: \.enableSMBAlways),
//                    infoText: NSLocalizedString(
//                        "Defaults to false. When true, always enable supermicrobolus (unless disabled by high temptarget).",
//                        comment: "Enable SMB"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: "Enable SMB With High BG",
//                    type: .boolean(keypath: \.enableSMB_high_bg),
//                    infoText: NSLocalizedString(
//                        "Enable SMBs when a high BG is detected, based on the high BG target (adjusted or profile). When this is enabled, Enable SMB should be off, to disable SMB's below High BG.",
//                        comment: "Enable SMB With High BG"
//                    ),
//                    settable: self
//                ),
                Field(
                    displayName: NSLocalizedString("Max Delta-BG Threshold MB", comment: "Max Delta-BG Threshold"),
                    type: .decimal(keypath: \.maxDeltaBGthreshold),
                    infoText: NSLocalizedString(
                        "Defaults to 0.2 (20%). Maximum positive percentual change of BG level to use MB, above that will disable MB. Hardcoded cap of 40%. For UAM fully-closed-loop 30% is advisable. Observe in log and popup (maxDelta 27 > 20% of BG 100 - disabling MB!).",
                        comment: "Max Delta-BG Threshold"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "MB DeliveryRatio",
                    type: .decimal(keypath: \.smbDeliveryRatio),
                    infoText: NSLocalizedString(
                        "Default value: 0.85 This is another key OpenAPS safety cap, and specifies what share of the total insulin required can be delivered as MB. This is to prevent people from getting into dangerous territory by setting MB requests from the caregivers phone at the same time. Increase this experimental value slowly and with caution. You can use that with ezFCL to increase the MB DR immediately indpendent of BG if you use an Eating Soon TT (even and below 100). This MB DR will then be used, independently of the 3 following options, that normally superceed his setting.",
                        comment: "MB DeliveryRatio"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("MB Threshold Ratio", comment: "MB Threshold Ratio"),
                    type: .decimal(keypath: \.smbThresholdRatio),
                    infoText: NSLocalizedString(
                        "Defaults to 0.75! Used to determine when MB's are disabled due to BG being low. Used in formula threshold = min_bg - (1-threshold_ratio) * (min_bg - 40). The higher the ratio the higher the threshold (BG) below which MB's are NOT applied. With 0.5 thresholds depending on target are: min_bg of 90 -> threshold of 65, 100 -> 70 110 -> 75, and 130 -> 85.  Minimum value is 0.5, max value is 1, at which the Threshold will be equal to Target BG.",
                        comment: "Max Delta-BG Threshold"
                    ),
                    settable: self
                ),
//                Field(
//                    displayName: NSLocalizedString("Enable SMB With COB", comment: "Enable SMB With COB"),
//                    type: .boolean(keypath: \.enableSMBWithCOB),
//                    infoText: NSLocalizedString(
//                        "This enables supermicrobolus (SMB) while carbs on board (COB) are positive.",
//                        comment: "Enable SMB With COB"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Enable SMB With Temptarget", comment: "Enable SMB With Temptarget"),
//                    type: .boolean(keypath: \.enableSMBWithTemptarget),
//                    infoText: NSLocalizedString(
//                        "This enables supermicrobolus (SMB) with eating soon / low temp targets. With this feature enabled, any temporary target below 100mg/dL, such as a temp target of 99 (or 80, the typical eating soon target) will enable SMB.",
//                        comment: "Enable SMB With Temptarget"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Enable SMB After Carbs", comment: "Enable SMB After Carbs"),
//                    type: .boolean(keypath: \.enableSMBAfterCarbs),
//                    infoText: NSLocalizedString(
//                        "Defaults to false. When true, enables supermicrobolus (SMB) for 6h after carbs, even with 0 carbs on board (COB).",
//                        comment: "Enable SMB After Carbs"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString(
//                        "Allow SMB With High Temptarget",
//                        comment: "Allow SMB With High Temptarget"
//                    ),
//                    type: .boolean(keypath: \.allowSMBWithHighTemptarget),
//                    infoText: NSLocalizedString(
//                        "Defaults to false. When true, allows supermicrobolus (if otherwise enabled) even with high temp targets (> 100 mg/dl).",
//                        comment: "Allow SMB With High Temptarget"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Enable UAM", comment: "Enable UAM"),
//                    type: .boolean(keypath: \.enableUAM),
//                    infoText: NSLocalizedString(
//                        "With this option enabled, the SMB algorithm can recognize unannounced meals. This is helpful, if you forget to tell ezFCL about your carbs or estimate your carbs wrong and the amount of entered carbs is wrong or if a meal with lots of fat and protein has a longer duration than expected. Without any carb entry, UAM can recognize fast glucose increasments caused by carbs, adrenaline, etc, and tries to adjust it with SMBs. This also works the opposite way: if there is a fast glucose decreasement, it can stop SMBs earlier.",
//                        comment: "Enable UAM"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Max SMB Basal Minutes", comment: "Max SMB Basal Minutes"),
//                    type: .decimal(keypath: \.maxSMBBasalMinutes),
//                    infoText: NSLocalizedString(
//                        "Defaults to start at 30. This is the maximum minutes of basal that can be delivered as a single SMB with uncovered COB. This gives the ability to make SMB more aggressive if you choose. It is recommended that the value is set to start at 30, in line with the default, and if you choose to increase this value, do so in no more than 15 minute increments, keeping a close eye on the effects of the changes. It is not recommended to set this value higher than 90 mins, as this may affect the ability for the algorithm to safely zero temp. It is also recommended that pushover is used when setting the value to be greater than default, so that alerts are generated for any predicted lows or highs.",
//                        comment: "Max SMB Basal Minutes"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Max UAM SMB Basal Minutes", comment: "Max UAM SMB Basal Minutes"),
//                    type: .decimal(keypath: \.maxUAMSMBBasalMinutes),
//                    infoText: NSLocalizedString(
//                        "Defaults to start at 30. This is the maximum minutes of basal that can be delivered by UAM as a single SMB when IOB exceeds COB. This gives the ability to make UAM more or less aggressive if you choose. It is recommended that the value is set to start at 30, in line with the default, and if you choose to increase this value, do so in no more than 15 minute increments, keeping a close eye on the effects of the changes. Reducing the value will cause UAM to dose less insulin for each SMB. It is not recommended to set this value higher than 60 mins, as this may affect the ability for the algorithm to safely zero temp. It is also recommended that pushover is used when setting the value to be greater than default, so that alerts are generated for any predicted lows or highs.",
//                        comment: "Max UAM SMB Basal Minutes"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("SMB Interval", comment: "SMB Interval"),
//                    type: .decimal(keypath: \.smbInterval),
//                    infoText: NSLocalizedString(
//                        "Minimum duration in minutes for new SMB since last SMB or manual bolus",
//                        comment: "SMB Interval"
//                    ),
//                    settable: self
//                ),
                Field(
                    displayName: NSLocalizedString("Bolus Increment", comment: "Bolus Increment"),
                    type: .decimal(keypath: \.bolusIncrement),
                    infoText: NSLocalizedString(
                        "Smallest enacted SMB amount. Minimum amount for Omnipod pumps is 0.05 U, whereas for Medtronic pumps it differs for various models, from 0.025 U to 0.10 U. Please check the minimum bolus amount which can be delivered by your pump. The default value is 0.1.",
                        comment: "Bolus Increment"
                    ),
                    settable: self
                )
            ]

            // MARK: - Targets fields

            let targetSettings = [
                Field(
                    displayName: NSLocalizedString(
                        "High Temptarget Raises Sensitivity (Exercise Mode)",
                        comment: "High Temptarget Raises Sensitivity (Exercise Mode)"
                    ),
                    type: .boolean(keypath: \.highTemptargetRaisesSensitivity),
                    infoText: NSLocalizedString(
                        "Defaults to false. When set to true, raises sensitivity (lower sensitivity ratio) for temp targets set to >= 111. Synonym for exercise_mode. The higher your temp target above 110 will result in more sensitive (lower) ratios, e.g., temp target of 120 results in sensitivity ratio of 0.75, while 140 results in 0.6 (with default halfBasalTarget of 160).",
                        comment: "High Temptarget Raises Sensitivity (Exercise Mode)"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString(
                        "Low Temptarget Lowers Sensitivity",
                        comment: "Low Temptarget Lowers Sensitivity"
                    ),
                    type: .boolean(keypath: \.lowTemptargetLowersSensitivity),
                    infoText: NSLocalizedString(
                        "Defaults to false. When set to true, can lower sensitivity (higher sensitivity ratio) for temptargets <= 99. The lower your temp target below 100 will result in less sensitive (higher) ratios, e.g., temp target of 95 results in sensitivity ratio of 1.09, while 85 results in 1.33 (with default halfBasalTarget of 160).",
                        comment: "Low Temptarget Lowers Sensitivity"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Sensitivity Raises Target", comment: "Sensitivity Raises Target"),
                    type: .boolean(keypath: \.sensitivityRaisesTarget),
                    infoText: NSLocalizedString(
                        "When true, raises BG target when autosens detects sensitivity",
                        comment: "Sensitivity Raises Target"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Resistance Lowers Target", comment: "Resistance Lowers Target"),
                    type: .boolean(keypath: \.resistanceLowersTarget),
                    infoText: NSLocalizedString(
                        "Defaults to false. When true, will lower BG target when autosens detects resistance",
                        comment: "Resistance Lowers Target"
                    ),
                    settable: self
                )
            ]

            // MARK: - Other fields

            let otherSettings = [
                //                Field(
//                    displayName: NSLocalizedString("Rewind Resets Autosens", comment: "Rewind Resets Autosens"),
//                    type: .boolean(keypath: \.rewindResetsAutosens),
//                    infoText: NSLocalizedString(
//                        "This feature, enabled by default, resets the autosens ratio to neutral when you rewind your pump, on the assumption that this corresponds to a probable site change. Autosens will begin learning sensitivity anew from the time of the rewind, which may take up to 6 hours. If you usually rewind your pump independently of site changes, you may want to consider disabling this feature.",
//                        comment: "Rewind Resets Autosens"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Skip Neutral Temps", comment: "Skip Neutral Temps"),
//                    type: .boolean(keypath: \.skipNeutralTemps),
//                    infoText: NSLocalizedString(
//                        "Defaults to false, so that ezFCL will set temps whenever it can, so it will be easier to see if the system is working, even when you are offline. This means ezFCL will set a “neutral” temp (same as your default basal) if no adjustments are needed. This is an old setting for OpenAPS to have the options to minimise sounds and notifications from the 'rig', that may wake you up during the night.",
//                        comment: "Skip Neutral Temps"
//                    ),
//                    settable: self
//                ),
                Field(
                    displayName: NSLocalizedString("Unsuspend If No Temp", comment: "Unsuspend If No Temp"),
                    type: .boolean(keypath: \.unsuspendIfNoTemp),
                    infoText: NSLocalizedString(
                        "Many people occasionally forget to resume / unsuspend their pump after reconnecting it. If you’re one of them, and you are willing to reliably set a zero temp basal whenever suspending and disconnecting your pump, this feature has your back. If enabled, it will automatically resume / unsuspend the pump if you forget to do so before your zero temp expires. As long as the zero temp is still running, it will leave the pump suspended.",
                        comment: "Unsuspend If No Temp"
                    ),
                    settable: self
                ),
                Field(
                    displayName: NSLocalizedString("Suspend Zeros IOB", comment: "Suspend Zeros IOB"),
                    type: .boolean(keypath: \.suspendZerosIOB),
                    infoText: NSLocalizedString(
                        "Default is false. Any existing temp basals during times the pump was suspended will be deleted and 0 temp basals to negate the profile basal rates during times pump is suspended will be added.",
                        comment: "Suspend Zeros IOB"
                    ),
                    settable: self
                ),
                Field(
                    displayName: "Flat Glucose Check",
                    type: .boolean(keypath: \.flatGlucoseCheck),
                    infoText: "Defaults to true. When true, if glucose values are too flat, ezFCL does not loop and eventually reverts back to the profile basal if glucose readings are flat for too long. When false, flat glucose values will not trigger the cessation of loops. You should set this to false when you are using a software calibrated CGM or when you are using a Calibration Slope and Intercept value other than 1 and 0 respectively. This helps to mitigate the risk of going low when a sensor's minimum glucose value boundary has been elevated due to software based calibration. Example: if the lowest value your software calibrated sensor will read is 90 (after calibration), and your glucose gets pegged at that value (because your actual glucose value is still falling), ezFCL will continue to assume that your glucose is trending down, and will maintain a 0 temp basal until the glucose level rises back above 90. You may need to restart the app for the change to apply.",
                    settable: self
                )
//                Field(
//                    displayName: NSLocalizedString("Min 5m Carbimpact", comment: "Min 5m Carbimpact"),
//                    type: .decimal(keypath: \.min5mCarbimpact),
//                    infoText: NSLocalizedString(
//                        "This is a setting for default carb absorption impact per 5 minutes. The default is an expected 8 mg/dL/5min. This affects how fast COB is decayed in situations when carb absorption is not visible in BG deviations. The default of 8 mg/dL/5min corresponds to a minimum carb absorption rate of 24g/hr at a CSF of 4 mg/dL/g.",
//                        comment: "Min 5m Carbimpact"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString(
//                        "Autotune ISF Adjustment Fraction",
//                        comment: "Autotune ISF Adjustment Fraction"
//                    ),
//                    type: .decimal(keypath: \.autotuneISFAdjustmentFraction),
//                    infoText: NSLocalizedString(
//                        "The default of 0.5 for this value keeps autotune ISF closer to pump ISF via a weighted average of fullNewISF and pumpISF. 1.0 allows full adjustment, 0 is no adjustment from pump ISF.",
//                        comment: "Autotune ISF Adjustment Fraction"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Remaining Carbs Fraction", comment: "Remaining Carbs Fraction"),
//                    type: .decimal(keypath: \.remainingCarbsFraction),
//                    infoText: NSLocalizedString(
//                        "This is the fraction of carbs we’ll assume will absorb over 4h if we don’t yet see carb absorption.",
//                        comment: "Remaining Carbs Fraction"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Remaining Carbs Cap", comment: "Remaining Carbs Cap"),
//                    type: .decimal(keypath: \.remainingCarbsCap),
//                    infoText: NSLocalizedString(
//                        "This is the amount of the maximum number of carbs we’ll assume will absorb over 4h if we don’t yet see carb absorption.",
//                        comment: "Remaining Carbs Cap"
//                    ),
//                    settable: self
//                ),
//                Field(
//                    displayName: NSLocalizedString("Noisy CGM Target Multiplier", comment: "Noisy CGM Target Multiplier"),
//                    type: .decimal(keypath: \.noisyCGMTargetMultiplier),
//                    infoText: NSLocalizedString(
//                        "Defaults to 1.3. Increase target by this amount when looping off raw/noisy CGM data",
//                        comment: "Noisy CGM Target Multiplier"
//                    ),
//                    settable: self
//                )
            ]

            sections = [
                //                FieldSection(
//                    displayName: NSLocalizedString("", comment: ""),
//                    fields: firstSMBToggle
//                ),
//                FieldSection(
//                    displayName: NSLocalizedString("Glucose Related Settings", comment: "Glucose Related Settings"),
//                    fields: glucoseFields
//                ),
                FieldSection(
                    displayName: NSLocalizedString("Quick Preferences", comment: "Quick Preferences"),
                    fields: quickPrefs
                ),
                FieldSection(
                    displayName: NSLocalizedString("TDD Calculates ISF and Basal", comment: "TDD Calculates ISF and Basal"),
                    fields: tddFields
                ),
                FieldSection(
                    displayName: NSLocalizedString("OpenAPS main settings", comment: "OpenAPS main settings"),
                    fields: mainFields
                ),
                FieldSection(
                    displayName: NSLocalizedString("OpenAPS SMB settings", comment: "OpenAPS main settings"),
                    fields: smbFields
                ),
                FieldSection(
                    displayName: NSLocalizedString("OpenAPS targets settings", comment: "OpenAPS targets settings"),
                    fields: targetSettings
                ),

                FieldSection(
                    displayName: NSLocalizedString("OpenAPS other settings", comment: "OpenAPS other settings"),
                    fields: otherSettings
                )
            ]
        }

        func set<T>(_ keypath: WritableKeyPath<Preferences, T>, value: T) {
            preferences[keyPath: keypath] = value
            save()
        }

        func get<T>(_ keypath: WritableKeyPath<Preferences, T>) -> T {
            preferences[keyPath: keypath]
        }

        func save() {
            provider.savePreferences(preferences)
        }
    }
}
