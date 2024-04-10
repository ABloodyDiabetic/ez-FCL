
import Foundation
import UIKit

enum Icon_: String, CaseIterable, Identifiable {
    case primary = "pod_colorful"
    case text = "ezFCL"
    case podBlack = "podTemplateBlack"
    case popWhite = "podTemplateWhite"
    case cyan = "ezFCL_Loop_Cyan_Text"
    case podPurple
    case catWithPod
    case catWithPodWhite = "catWithPodWhiteBG"
    case loopWhiteText = "ezFCL_Loop_White_Text"
    case loopText = "ezFCL_Loop_Text"
    case black = "ezFCL_Black_Black"
    case clean = "ezFCL_Clean"
    case purple = "ezFCL_Purple"
    case glow = "ezFCL_Glow_BG"
    case gray = "ezFCL_Gray"
    case whiteAndGray = "ezFCL_WhiteAndGray"
    case grayAndLoopNoButtons = "ezFCL_NoButtons_Gray_White_BG"
    case purpleBG = "ezFCL_Purple_BG"
    case whiteBG = "ezFCL_White_BG"
    case loop = "ezFCL_Loop"
    var id: String { rawValue }
}

class Icons: ObservableObject, Equatable {
    @Published var appIcon: Icon_ = .primary

    static func == (lhs: Icons, rhs: Icons) -> Bool {
        lhs.appIcon == rhs.appIcon
    }

    func setAlternateAppIcon(icon: Icon_) {
        let iconName: String? = (icon != .primary) ? icon.rawValue : nil

        guard UIApplication.shared.alternateIconName != iconName else { return }

        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Failed request to update the app’s icon: \(error)")
            }
        }

        appIcon = icon
    }

    init() {
        let iconName = UIApplication.shared.alternateIconName

        if iconName == nil {
            appIcon = .primary
        } else {
            appIcon = Icon_(rawValue: iconName!)!
        }
    }
}
