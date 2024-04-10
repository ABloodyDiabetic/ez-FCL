import SwiftUI
import Swinject

struct BulletList: View {
    var withBorder: Bool = false
    var toInfinity: Bool = true
    var alignLeft: Bool = true
    var borderWidth: CGFloat {
        withBorder ? 1 : 0
    }

    var textFrameMaxWidth: CGFloat? {
        toInfinity ? .infinity : nil
    }

    var textFrameAlignment: Alignment {
        alignLeft ? .leading : .center
    }

    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var bullet: String = "•"
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: listItemSpacing
        ) {
            ForEach(listItems, id: \.self) { data in
                HStack(alignment: .top) {
                    Text(bullet)
                        .frame(
                            width: bulletWidth,
                            alignment: bulletAlignment
                        )
                        .border(
                            Color.blue,
                            width: borderWidth
                        )
                    Text(data)
                        .frame(
                            maxWidth: textFrameMaxWidth,
                            alignment: textFrameAlignment
                        )
                        .border(
                            Color.orange,
                            width: borderWidth
                        )
                }
            }
        }
        .padding(2)
        .border(.green, width: borderWidth)
    }
}

extension AutoISFConf {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()

        private var formatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }

        @State private var infoButtonPressed: InfoText?
        @Environment(\.colorScheme) var colorScheme

        private var color: LinearGradient {
            colorScheme == .dark ? LinearGradient(
                gradient: Gradient(colors: [
                    Color.bgDarkBlue,
                    Color.bgDarkerDarkBlue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
                :
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
        }

        var body: some View {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Toggle("Enable ezFCL", isOn: $state.autoisf)
                        }
                        .padding(.bottom, 2)
                        if !state.autoisf {
                            VStack(alignment: .leading) {
                                Text(
                                    "When enabled, ezFCL achieves a *near* Fully Closed Loop once the ezFCL and 'TDD ISF Adjustment Factor' settings have been properly configured. ezFCL achieves autonomous glucose control by adjusting the insulin sensitivity factor (ISF) up or down as necessary to regulate blood glucose levels. It accounts for:"
                                )
                                BulletList(
                                    listItems:
                                    [
                                        "accelerating or decelerating blood glucose values (acce)",
                                        "glucose deltas (Δ)",
                                        "and glucose plateaus (---)"
                                    ],
                                    listItemSpacing: 10
                                )
                            }
                            // .padding(10)
                            Text("when calculating ezFCL ISFs.")
                            Text(
                                "\n\n * Without a bi-hormonal system (a pump, or pumps that administer both insulin and glucagon concurrently) it will still be necessary to treat low BG values with glucose on some occasions. *"
                            )
                        }
                    }
                } header: { Text("Enable") }
                if state.autoisf {
                    ForEach(state.sections.indexed(), id: \.1.id) { sectionIndex, section in
                        Section(header: Text(section.displayName)) {
                            ForEach(section.fields.indexed(), id: \.1.id) { fieldIndex, field in
                                HStack {
                                    switch field.type {
                                    case .boolean:
                                        ZStack {
                                            Button("", action: {
                                                infoButtonPressed = InfoText(
                                                    description: field.infoText,
                                                    oref0Variable: field.displayName
                                                )
                                            })
                                            Toggle(isOn: self.$state.sections[sectionIndex].fields[fieldIndex].boolValue) {
                                                Text(field.displayName)
                                            }
                                        }
                                    case .decimal:
                                        ZStack {
                                            Button("", action: {
                                                infoButtonPressed = InfoText(
                                                    description: field.infoText,
                                                    oref0Variable: field.displayName
                                                )
                                            })
                                            Text(field.displayName)
                                        }
                                        DecimalTextField(
                                            "0",
                                            value: self.$state.sections[sectionIndex].fields[fieldIndex].decimalValue,
                                            formatter: formatter
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden).background(color)
            .onAppear(perform: configureView)
            .navigationTitle("ezFCL Configuration")
            .navigationBarTitleDisplayMode(.automatic)
            .alert(item: $infoButtonPressed) { infoButton in
                Alert(
                    title: Text("\(infoButton.oref0Variable)"),
                    message: Text("\(infoButton.description)"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onDisappear {
                state.saveIfChanged()
            }
        }

        func createParagraphAttribute(
            tabStopLocation: CGFloat,
            defaultTabInterval: CGFloat,
            firstLineHeadIndent: CGFloat,
            headIndent: CGFloat
        ) -> NSParagraphStyle {
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            let options: [NSTextTab.OptionKey: Any] = [:]
            paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: tabStopLocation, options: options)]
            paragraphStyle.defaultTabInterval = defaultTabInterval
            paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
            paragraphStyle.headIndent = headIndent
            return paragraphStyle
        }
    }
}
