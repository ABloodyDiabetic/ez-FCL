import SwiftDate
import SwiftUI
import UIKit

struct LoopView: View {
    private enum Config {
        static let lag: TimeInterval = 30
    }

    @Environment(\.colorScheme) var colorScheme

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
    
    private let rect = CGRect(x: 0, y: 0, width: 27, height: 27) // Adjust rect size to ensure it accommodates the scaling
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                if isLooping {
                    PulsatingCircleView(color: color)
                        .frame(width: rect.width, height: rect.height, alignment: .center)
                   /* ProgressView() */
                } else {
                    Circle()
                        .strokeBorder(color, lineWidth: 4.5)
                        .frame(width: rect.width, height: rect.height, alignment: .center)
                        .mask(mask(in: rect).fill(style: FillStyle(eoFill: true)))
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

struct PulsatingCircleView: View {
    var color: Color
    var size: CGFloat = 27.0
    @State private var animate = false

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(animate ? 0.5 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                    value: animate
                )
                .mask(
                    ZStack {
                        Circle()
                            .frame(width: size, height: size)
                        Circle()
                            .frame(width: size - 9, height: size - 9) // Adjust size to create cutaway effect
                            .scaleEffect(animate ? 0.0 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                                value: animate
                            )
                            .blendMode(.destinationOut) // This will cut out the shape from the layer below
                    }
                    .mask(mask(in: CGRect(x: 0, y: 0, width: size, height: size)).fill(style: FillStyle(eoFill: true)))
                )
        }
        .compositingGroup() // Ensure proper rendering of the blend mode
        .onAppear {
            self.animate = true
        }
    }

    func mask(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        path.addPath(Rectangle().path(in: CGRect(x: rect.minX, y: rect.midY - 5, width: rect.width, height: 10)))
        return path
    }
}
