import HealthKit
import SwiftDate
import SwiftUI

struct CurrentGlucoseView: View {
    @EnvironmentObject var state: WatchStateModel
    @State private var rotationDegrees: Double = 0.0
    @State private var angularGradient = AngularGradient(colors: [
        Color(red: 0.7215686275, green: 0.3411764706, blue: 1),
        Color(red: 0.6235294118, green: 0.4235294118, blue: 0.9803921569),
        Color(red: 0.4862745098, green: 0.5450980392, blue: 0.9529411765),
        Color(red: 0.3411764706, green: 0.6666666667, blue: 0.9254901961),
        Color(red: 0.262745098, green: 0.7333333333, blue: 0.9137254902),
        Color(red: 0.7215686275, green: 0.3411764706, blue: 1)
    ], center: .center, startAngle: .degrees(270), endAngle: .degrees(-90))

    @Environment(\.colorScheme) var colorScheme

    private enum Config {
        static let lag: TimeInterval = 30
    }

    private var timeString: String {
        let minAgo = Int((Date().timeIntervalSince(state.lastLoopDate ?? .distantPast) - Config.lag) / 60) + 1
        if minAgo > 1440 {
            return "--"
        }
        return "\(minAgo) " + NSLocalizedString("min", comment: "Minutes ago since last loop")
    }

    var loopTime: some View {
        VStack {
            if state.lastLoopDate != nil {
                let minutesPassed = Int(timeString) ?? 0
                if minutesPassed > 5 {
                    Text(timeString).fontWeight(.semibold).font(.caption2)
                } else {
                    Text("").fontWeight(.semibold).font(.caption2)
                    if let eventualBG = state.eventualBG.nonEmpty {
                        Text(eventualBG)
                            .font(.caption2)
                            .scaledToFill()
                            .foregroundColor(.secondary)
                            .minimumScaleFactor(0.75)
                            .offset(x: 0, y: 0)
                    } else {
                        EmptyView()
                    }
                }
            } else {
                Text("--").fontWeight(.semibold).font(.caption2)
            }
        }
    }

    var body: some View {
        let triangleColor = Color(red: 0.262745098, green: 0.7333333333, blue: 0.9137254902)

        ZStack {
            TrendShape(gradient: angularGradient, color: triangleColor)
                .rotationEffect(.degrees(rotationDegrees))

            VStack(alignment: .center) {
                let minutesAgo: TimeInterval = -1 * (state.glucoseDate ?? .distantPast).timeIntervalSinceNow / 60
                let minuteString = minutesAgo > 99 ? "--" : minutesAgo
                    .formatted(.number.grouping(.never).rounded().precision(.fractionLength(0)))
                HStack {
                    Text(state.glucose)
                        .font(.system(size: 40, weight: .bold))
                    /* .foregroundColor(alarm == nil ? colourGlucoseText : .loopRed) */
                }
                HStack {
                    if minutesAgo > 0 {
                        /* Text(minuteString)
                         Text("min ")
                         Text(state.delta) */
                        Text(minuteString)
                        Text("min  ")
                        Text(state.delta)
                        Text(state.trend)
                            .offset(x: 0, y: -1.75)
                    }
                }
            }
            loopTime
                .offset(x: 0, y: 43)
        }
        .onAppear {
            updateRotationBasedOnTrend(state.trend)
        }
        .onChange(of: state.trend) { newTrend in
            withAnimation(.easeInOut(duration: 0.5)) {
                updateRotationBasedOnTrend(newTrend)
            }
        }
    }

    private func updateRotationBasedOnTrend(_ trend: String?) {
        let oldDegrees = rotationDegrees
        switch state.trend {
        case "→":
            rotationDegrees = 0
        case "↗":
            rotationDegrees = -45
        case "↑":
            rotationDegrees = -90
        case "↘":
            rotationDegrees = 45
        case "↓":
            rotationDegrees = 90
        default:
            rotationDegrees = 0
        }
        print("Updated rotation from \(oldDegrees) to \(rotationDegrees) for trend \(trend ?? "unknown")")
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY + 15))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.midY + 13))

        path.closeSubpath()

        return path
    }
}

struct TrendShape: View {
    @Environment(\.colorScheme) var colorScheme

    let gradient: AngularGradient
    let color: Color

    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Group {
                    CircleShape(gradient: gradient)
                    TriangleShape(color: color)
                }.shadow(
                    color: Color.black.opacity( /* colorScheme == .dark ? */ 0.75 /*: 0.33 */ ),
                    radius: /* colorScheme == .dark ? */ 5 /*: 3 */
                )
                CircleShape(gradient: gradient)
            }
        }
    }
}

struct CircleShape: View {
    @Environment(\.colorScheme) var colorScheme

    let gradient: AngularGradient

    var body: some View {
        Circle()
            .stroke(gradient, lineWidth: 6)
            .background(Circle().fill(Color("Color")))
            .frame(width: 130, height: 130)
    }
}

struct TriangleShape: View {
    let color: Color

    var body: some View {
        Triangle()
            .fill(color)
            .frame(width: 35, height: 35)
            .rotationEffect(.degrees(90))
            .offset(x: 85)
    }
}
