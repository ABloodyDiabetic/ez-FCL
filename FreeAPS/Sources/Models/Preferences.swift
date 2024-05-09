import Foundation

struct Preferences: JSON {
    var carbProfileDuration: Decimal = 210
    var enableMiddleware: Bool = false
    var disableMBDuringSleep: Bool = true
    var basalMultiplier: Decimal = 1
    var automaticSleepMode: Bool = false
    var sleepMode: Bool = false
    var enableMaxIobDeadbands: Bool = true
    var maxIobTightDeadband: Decimal = 1.25
    var maxIobLooseDeadband: Decimal = 2.5
    var tightDeadbandRange: Decimal = 5
    var looseDeadbandRange: Decimal = 10
    var calculateIsfFromTddNumeratorDivisor: Decimal = 0.75
    var adjustBasalInverselyToAutosensIsf: Bool = false
    var useAutosensIsfToCalculateAutoIsfSens: Bool = true
    var flatGlucoseCheck: Bool = false
    var glucoseCalibrationSlope: Decimal = 1
    var glucoseCalibrationIntercept: Decimal = 0
    var maxIOB: Decimal = 33.33
    var maxDailySafetyMultiplier: Decimal = 3
    var currentBasalSafetyMultiplier: Decimal = 4
    var enableAutosens = true
    var autosensMax: Decimal = 5
    var autosensMin: Decimal = 0.1
    var smbDeliveryRatio: Decimal = 0.85
    var rewindResetsAutosens: Bool = false
    var highTemptargetRaisesSensitivity: Bool = false
    var lowTemptargetLowersSensitivity: Bool = false
    var sensitivityRaisesTarget: Bool = true
    var resistanceLowersTarget: Bool = true
    var advTargetAdjustments: Bool = false
    var exerciseMode: Bool = false
    var halfBasalExerciseTarget: Decimal = 160
    var maxCOB: Decimal = 120
    var wideBGTargetRange: Bool = false
    var skipNeutralTemps: Bool = false
    var unsuspendIfNoTemp: Bool = false
    var min5mCarbimpact: Decimal = 8
    var autotuneISFAdjustmentFraction: Decimal = 1.0
    var remainingCarbsFraction: Decimal = 1.0
    var remainingCarbsCap: Decimal = 90
    var enableUAM: Bool = true
    var a52RiskEnable: Bool = false
    var enableSMBWithCOB: Bool = false
    var enableSMBWithTemptarget: Bool = false
    var enableSMBAlways: Bool = true
    var enableSMB_high_bg: Bool = false
    var enableSMB_high_bg_target: Decimal = 90
    var enableSMBAfterCarbs: Bool = false
    var allowSMBWithHighTemptarget: Bool = false
    var maxSMBBasalMinutes: Decimal = 120
    var maxUAMSMBBasalMinutes: Decimal = 120
    var smbInterval: Decimal = 3
    var bolusIncrement: Decimal = 0.1
    var curve: InsulinCurve = .ultraRapid
    var useCustomPeakTime: Bool = true
    var insulinPeakTime: Decimal = 35
    var carbsReqThreshold: Decimal = 1.0
    var noisyCGMTargetMultiplier: Decimal = 1.3
    var suspendZerosIOB: Bool = false
    var timestamp: Date?
    var maxDeltaBGthreshold: Decimal = 0.3
    // start dynISF config for oref variables
    var adjustmentFactor: Decimal = 0.5
    var sigmoid: Bool = false
    var enableDynamicCR: Bool = false
    var useNewFormula: Bool = false
    var useWeightedAverage: Bool = false
    var weightPercentage: Decimal = 0.65
    var tddAdjBasal: Bool = false
    var threshold_setting: Decimal = 65
    var updateInterval: Decimal = 20
    // start autoISF config
//    var profiles: DefaultezFCLProfile = .lowCarbezFCLProfile
    var profileDuration: Decimal = 6
    var ezFCLAccelerationMultiplier: Decimal = 1
    var ezFCLDeltaMultiplier: Decimal = 1
    var ezFCLPlateauMultiplier: Decimal = 1
    var ezFCLWeight: Decimal = 0.25
    var lowCarbezFCLProfile: Bool = true
    var moderateCarbezFCLProfile: Bool = false
    var highCarbezFCLProfile: Bool = false
    var lowCarbezFCLProfileMultiplier: Decimal = 0.14
    var moderateCarbezFCLProfileMultiplier: Decimal = 0.666
    var highCarbezFCLProfileMultiplier: Decimal = 1
    var floatingcarbs: Bool = true
    var autoisf: Bool = true
    var autoISFmax: Decimal = 8
    var autoISFmin: Decimal = 0.65
    var smbMaxRangeExtension: Decimal = 3.5
    var smbThresholdRatio: Decimal = 0.75
    var smbDeliveryRatioBGrange: Decimal = 0
    var smbDeliveryRatioMin: Decimal = 0.85
    var smbDeliveryRatioMax: Decimal = 0.85
    var enableautoISFwithCOB: Bool = false
    var autoISFhourlyChange: Decimal = 3.61
    var higherISFrangeWeight: Decimal = 0
    var lowerISFrangeWeight: Decimal = 0
    var deltaISFrangeWeight: Decimal = 0
    var postMealISFalways: Bool = true
    var postMealISFweight: Decimal = 0.29
    var postMealISFduration: Decimal = 3
    var enableBGacceleration: Bool = true
    var bgAccelISFweight: Decimal = 0.875
    var bgBrakeISFweight: Decimal = 0.569
    var iobThresholdPercent: Decimal = 100
    var enableSMBEvenOnOddOff: Bool = false
    var enableSMBEvenOnOddOffalways: Bool = false
    var autoISFoffSport: Bool = false
    // start B30 config
    var enableB30: Bool = false
    var B30iTimeStartBolus: Decimal = 1.5
    var B30iTime: Decimal = 30
    var B30iTimeTarget: Decimal = 90
    var B30upperLimit: Decimal = 130
    var B30upperDelta: Decimal = 8
    var B30basalFactor: Decimal = 7
}

extension Preferences {
    private enum CodingKeys: String, CodingKey {
        case carbProfileDuration
        case enableMiddleware
        case disableMBDuringSleep = "disable_mb_during_sleep"
        case basalMultiplier = "basal_multiplier"
        case automaticSleepMode = "automatic_sleep_mode"
        case sleepMode = "sleep_mode"
        case enableMaxIobDeadbands = "enable_max_iob_deadbands"
        case maxIobTightDeadband = "max_iob_tight_deadband"
        case maxIobLooseDeadband = "max_iob_loose_deadband"
        case tightDeadbandRange = "tight_deadband_range"
        case looseDeadbandRange = "loose_deadband_range"
        case calculateIsfFromTddNumeratorDivisor = "calculate_isf_from_tdd_numerator_divisor"
        case adjustBasalInverselyToAutosensIsf = "adjust_basal_inversely_to_autosens_isf"
        case useAutosensIsfToCalculateAutoIsfSens = "use_autosens_isf_to_calculate_auto_isf_sens"
        case flatGlucoseCheck = "flat_glucose_check"
        case glucoseCalibrationSlope = "glucose_calibration_slope"
        case glucoseCalibrationIntercept = "glucose_calibration_intercept"
        case maxIOB = "max_iob"
        case maxDailySafetyMultiplier = "max_daily_safety_multiplier"
        case currentBasalSafetyMultiplier = "current_basal_safety_multiplier"
        case enableAutosens = "enable_autosens"
        case autosensMax = "autosens_max"
        case autosensMin = "autosens_min"
        case smbDeliveryRatio = "smb_delivery_ratio"
        case rewindResetsAutosens = "rewind_resets_autosens"
        case highTemptargetRaisesSensitivity = "high_temptarget_raises_sensitivity"
        case lowTemptargetLowersSensitivity = "low_temptarget_lowers_sensitivity"
        case sensitivityRaisesTarget = "sensitivity_raises_target"
        case resistanceLowersTarget = "resistance_lowers_target"
        case advTargetAdjustments = "adv_target_adjustments"
        case exerciseMode = "exercise_mode"
        case halfBasalExerciseTarget = "half_basal_exercise_target"
        case maxCOB
        case wideBGTargetRange = "wide_bg_target_range"
        case skipNeutralTemps = "skip_neutral_temps"
        case unsuspendIfNoTemp = "unsuspend_if_no_temp"
        case min5mCarbimpact = "min_5m_carbimpact"
        case autotuneISFAdjustmentFraction = "autotune_isf_adjustmentFraction"
        case remainingCarbsFraction
        case remainingCarbsCap
        case enableUAM
        case a52RiskEnable = "A52_risk_enable"
        case enableSMBWithCOB = "enableSMB_with_COB"
        case enableSMBWithTemptarget = "enableSMB_with_temptarget"
        case enableSMBAlways = "enableSMB_always"
        case enableSMBAfterCarbs = "enableSMB_after_carbs"
        case allowSMBWithHighTemptarget = "allowSMB_with_high_temptarget"
        case maxSMBBasalMinutes
        case maxUAMSMBBasalMinutes
        case smbInterval = "SMBInterval"
        case bolusIncrement = "bolus_increment"
        case curve
        case useCustomPeakTime
        case insulinPeakTime
        case carbsReqThreshold
        case noisyCGMTargetMultiplier
        case suspendZerosIOB = "suspend_zeros_iob"
        case smbDeliveryRatioBGrange = "smb_delivery_ratio_bg_range"
        case maxDeltaBGthreshold = "maxDelta_bg_threshold"
        // start dynISF config for oref variables
        case adjustmentFactor
        case sigmoid
        case enableDynamicCR
        case useNewFormula
        case useWeightedAverage
        case weightPercentage
        case tddAdjBasal
        case enableSMB_high_bg
        case enableSMB_high_bg_target
        case threshold_setting
        case updateInterval
        // start autoISF config for oref variables
//        case profiles
        case profileDuration = "profile_duration"
        case ezFCLAccelerationMultiplier = "ez_fcl_acceleration_multiplier"
        case ezFCLDeltaMultiplier = "ez_fcl_delta_multiplier"
        case ezFCLPlateauMultiplier = "ez_fcl_plateau_multiplier"
        case ezFCLWeight = "ez_fcl_weight"
        case lowCarbezFCLProfile = "low_carb_ez_fcl_profile"
        case moderateCarbezFCLProfile = "moderate_carb_ez_fcl_profile"
        case highCarbezFCLProfile = "high_carb_ez_fcl_profile"
        case lowCarbezFCLProfileMultiplier = "low_carb_ez_fcl_profile_multiplier"
        case moderateCarbezFCLProfileMultiplier = "moderate_carb_ez_fcl_profile_multiplier"
        case highCarbezFCLProfileMultiplier = "high_carb_ez_fcl_profile_multiplier"
        case autoisf = "use_autoisf"
        case autoISFhourlyChange = "dura_ISF_weight"
        case autoISFmax = "autoISF_max"
        case autoISFmin = "autoISF_min"
        case smbMaxRangeExtension = "smb_max_range_extension"
        case floatingcarbs = "floating_carbs"
        case iobThresholdPercent = "iob_threshold_percent"
        case enableSMBEvenOnOddOff = "enableSMB_EvenOn_OddOff"
        case enableSMBEvenOnOddOffalways = "enableSMB_EvenOn_OddOff_always"
        case smbDeliveryRatioMin = "smb_delivery_ratio_min"
        case smbDeliveryRatioMax = "smb_delivery_ratio_max"
        case smbThresholdRatio = "smb_threshold_ratio"
        case enableautoISFwithCOB = "enableautoisf_with_COB"
        case higherISFrangeWeight = "higher_ISFrange_weight"
        case lowerISFrangeWeight = "lower_ISFrange_weight"
        case deltaISFrangeWeight = "delta_ISFrange_weight"
        case postMealISFweight = "pp_ISF_weight"
        case postMealISFduration = "pp_ISF_hours"
        case postMealISFalways = "enable_pp_ISF_always"
        case bgAccelISFweight = "bgAccel_ISF_weight"
        case bgBrakeISFweight = "bgBrake_ISF_weight"
        case enableBGacceleration = "enable_BG_acceleration"
        case autoISFoffSport = "autoISF_off_Sport"
        // start B30 config
        case enableB30 = "use_B30"
        case B30iTimeStartBolus = "iTime_Start_Bolus"
        case B30iTime = "b30_duration"
        case B30iTimeTarget = "iTime_target"
        case B30upperLimit = "b30_upperBG"
        case B30upperDelta = "b30_upperdelta"
        case B30basalFactor = "b30_factor"
    }
}

enum InsulinCurve: String, JSON, Identifiable, CaseIterable {
    case rapidActing = "rapid-acting"
    case ultraRapid = "ultra-rapid"
    //        case bilinear

    var id: InsulinCurve { self }
}

// enum DefaultezFCLProfile: String, JSON, Identifiable, CaseIterable {
//    case lowCarbezFCLProfile = "low-carb-ez-fcl-profile"
//    case moderateCarbezFCLProfile = "moderate-carb-ez-fcl-profile"
//    case highCarbezFCLProfile = "high-carb-ez-fcl-profile"

//    var id: DefaultezFCLProfile { self }
// }
