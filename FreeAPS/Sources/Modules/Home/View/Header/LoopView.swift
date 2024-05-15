import SwiftDate
import SwiftUI
import UIKit

private var backgroundGradient: LinearGradient {
    LinearGradient(
        gradient: Gradient(colors: [
            Color.bgDarkBlue,
            Color.bgDarkerDarkBlue,
            Color.bgDarkBlue
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}

struct LoopView: View {
    private enum Config {
        static let lag: TimeInterval = 30
    }

    @Binding var suggestion: Suggestion?
    @Binding var enactedSuggestion: Suggestion?
    @Binding var closedLoop: Bool
    @Binding var timerDate: Date
    @Binding var isLooping: Bool
    @Binding var lastLoopDate: Date
    @Binding var manualTempBasal: Bool
    @State private var scale: CGFloat = 1.0

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                if isLooping {
                    PulsatingCircleView()
                   /* ProgressView() */
                } else {
                    Circle()
                        .strokeBorder(color, lineWidth: 5)
                        .frame(width: 30, height: 30)
                        .scaleEffect(1)
                }
            }
            if isLooping {
               /* Text("looping").font(.caption2) */
                Text(timeString).font(.caption2)
                    .foregroundColor(.secondary)
            } else if manualTempBasal {
                Text("Manual").font(.caption2)
            } else if actualSuggestion?.timestamp != nil {
                Text(timeString).font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                Text("--").font(.caption2).foregroundColor(.secondary)
            }
        }
    }

    private var timeString: String {
        let minAgo = Int((timerDate.timeIntervalSince(lastLoopDate) - Config.lag) / 60) + 1
        if minAgo > 1440 {
            return "--"
        }
        return "\(minAgo) " + NSLocalizedString("min", comment: "Minutes ago since last loop")
    }

    private var color: Color {
        guard actualSuggestion?.timestamp != nil else {
            return .loopGray
        }
        guard manualTempBasal == false else {
            return .loopManualTemp
        }
        let delta = timerDate.timeIntervalSince(lastLoopDate) - Config.lag

        if delta <= 5.minutes.timeInterval {
            guard actualSuggestion?.deliverAt != nil else {
                return .loopYellow
            }
            return .loopGreen
        } else if delta <= 10.minutes.timeInterval {
            return .loopYellow
        } else {
            return .loopRed
        }
    }

    func mask(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        if !closedLoop || manualTempBasal {
            path.addPath(Rectangle().path(in: CGRect(x: rect.minX, y: rect.midY - 5, width: rect.width, height: 10)))
        }
        return path
    }

    private var actualSuggestion: Suggestion? {
        if closedLoop, enactedSuggestion?.recieved == true {
            return enactedSuggestion ?? suggestion
        } else {
            return suggestion
        }
    }
}

/* extension View {
    func animateForever(
        using animation: Animation = Animation.easeInOut(duration: 1),
        autoreverses: Bool = false,
        _ action: @escaping () -> Void
    ) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)

        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
} */

import SwiftUI

struct PulsatingCircleView: View {
    var size: CGFloat = 20.0
    @State private var animate = false

    private let maxScale: CGFloat = 1.0
    private let minScale: CGFloat = 0.5

    private let startColor = Color.loopGreen
    private let middleColor = Color(red: 0.6235294118, green: 0.4235294118, blue: 0.9803921569)
    private let endColor = Color(red: 0.262745098, green: 0.7333333333, blue: 0.9137254902)

    var body: some View {
        ZStack {
            Circle()
                .fill(interpolatedColor(for: animate ? minScale : maxScale))
                .frame(width: 30, height: 30)
                .scaleEffect(animate ? minScale : maxScale)
                .animation(
                    Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                    value: animate
                )
            Circle()
                .fill(backgroundGradient)
                .frame(width: 20, height: 20)
                .scaleEffect(animate ? 0.0 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                    value: animate
                )
        }
        .onAppear {
            self.animate = true
        }
    }

    private func interpolatedColor(for scale: CGFloat) -> Color {
        // Normalize the scale to a range between 0 and 1
        let normalizedScale = (scale - minScale) / (maxScale - minScale)

        // Calculate the interpolation factor
        if normalizedScale <= 0.5 {
            // Interpolate between startColor and middleColor
            let factor = normalizedScale / 0.5
            return Color(
                red: (1 - factor) * startColor.components.red + factor * middleColor.components.red,
                green: (1 - factor) * startColor.components.green + factor * middleColor.components.green,
                blue: (1 - factor) * startColor.components.blue + factor * middleColor.components.blue
            )
        } else {
            // Interpolate between middleColor and endColor
            let factor = (normalizedScale - 0.5) / 0.5
            return Color(
                red: (1 - factor) * middleColor.components.red + factor * endColor.components.red,
                green: (1 - factor) * middleColor.components.green + factor * endColor.components.green,
                blue: (1 - factor) * middleColor.components.blue + factor * endColor.components.blue
            )
        }
    }
}

extension Color {
    struct ColorComponents {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
    }

    var components: ColorComponents {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        let result = scanner.scanHexInt64(&hexNumber)
        let r, g, b: CGFloat
        if result {
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000ff) / 255
            return ColorComponents(red: r, green: g, blue: b)
        } else {
            return ColorComponents(red: 0, green: 0, blue: 0)
        }
    }
}

