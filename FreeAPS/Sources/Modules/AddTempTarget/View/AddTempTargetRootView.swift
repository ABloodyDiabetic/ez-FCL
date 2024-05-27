import CoreData
import SwiftUI
import Swinject

extension AddTempTarget {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()
        @State private var isPromptPresented = false
        @State private var isRemoveAlertPresented = false
        @State private var removeAlert: Alert?
        @State private var isEditing = false
        @State private var tempHighCarbProfileEnabled: Bool = false
        @State private var tempMediumCarbProfileEnabled: Bool = false
        @State private var tempLowCarbProfileEnabled: Bool = false
        @State private var tempSleepModeEnabled: Bool = false
        @Injected() private var storage: FileStorage!

        @FetchRequest(
            entity: TempTargetsSlider.entity(),
            sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]
        ) var isEnabledArray: FetchedResults<TempTargetsSlider>

        @Environment(\.colorScheme) var colorScheme

        private var formatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            return formatter
        }

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
                if !state.presets.isEmpty {
                    Section {
                        ForEach(state.presets) { preset in
                            presetView(for: preset)
                        }
                    }
                }

//                HStack {
//                    Text("Advanced TT")
//                    Toggle(isOn: $state.viewPercantage) {}.controlSize(.mini)
//                    Image(systemName: "figure.highintensity.intervaltraining")
//                    Image(systemName: "fork.knife")
//                }

//                if state.viewPercantage {
//                    Section(header: Text("TT Effect on Insulin")) {
//                        ttEffectOnInsulinView
//                    }
//                } else {
                customSectionView
//                }

                Section {
                    HStack {
                        Spacer() // Pushes the button to the center
                        Button(action: state.enact) {
                            Text("Start")
                                .frame(maxWidth: .infinity) // Ensures the button text is centered within the button
                        }
                        Spacer() // Pushes the button to the center
                    }

                    HStack {
                        Spacer() // Pushes the button to the center
                        Button(action: state.cancel) {
                            Text("Cancel")
                                .frame(maxWidth: .infinity) // Ensures the button text is centered within the button
                        }
                        Spacer() // Pushes the button to the center
                    }
                }
            }

            .scrollContentBackground(.hidden)
            .background(color)
            .popover(isPresented: $isPromptPresented) {
                presetNamePopoverView
            }
            .onAppear {
                let cd = CoreDataStorage()
                let tempTargetsArray = cd.fetchTempTargets()
                let duration = Int(truncating: tempTargetsArray.first?.duration ?? 0)
                let startDate = tempTargetsArray.first?.startDate ?? Date()
                let durationPlusStart = startDate.addingTimeInterval(duration.minutes.timeInterval) // Convert minutes to seconds
                var remainingMinutes = max(0, durationPlusStart.timeIntervalSinceNow.minutes) // Ensure not negative

                configureView()

                // Setup state values
                //  state.hbt = isEnabledArray.first?.hbt ?? 160
                state.tempHighCarbProfileEnabled = state.settingsManager.preferences.highCarbezFCLProfile
                state.tempMediumCarbProfileEnabled = state.settingsManager.preferences.moderateCarbezFCLProfile
                state.tempLowCarbProfileEnabled = state.settingsManager.preferences.lowCarbezFCLProfile
                state.duration = Decimal(remainingMinutes)
                state.low = Decimal(Double(truncating: tempTargetsArray.first?.low ?? 0)) // Assuming 'low' is a Double or similar

                // Carb profile selection
                if state.tempSleepModeEnabled {
                    state.carbProfileSelection = "Conservative"
                } else if state.tempLowCarbProfileEnabled {
                    state.carbProfileSelection = "Low"
                } else if state.tempMediumCarbProfileEnabled {
                    state.carbProfileSelection = "Medium"
                } else if state.tempHighCarbProfileEnabled {
                    state.carbProfileSelection = "High"
                }
            }
            .navigationTitle("Temp Profiles")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        state.hideModal()
                    }
                }
            }
        }

//        var ttEffectOnInsulinView: some View {
//            VStack {
//                HStack {
//                    Text(NSLocalizedString("Target", comment: ""))
//                    Spacer()
//                    DecimalTextField(
//                        "0",
//                        value: $state.low,
//                        formatter: formatter,
//                        cleanInput: true
//                    )
//                    Text(state.units.rawValue).foregroundColor(.secondary)
//                }

//                if computeSliderLow() != computeSliderHigh() {
//                    Text("\(state.percentage.formatted(.number)) % Insulin")
//                        .foregroundColor(isEditing ? .orange : .blue)
//                        .font(.largeTitle)
//                    Slider(
//                        value: $state.percentage,
//                        in: computeSliderLow() ... computeSliderHigh(),
//                        step: 5
//                    ) {}
//                    minimumValueLabel: { Text("\(computeSliderLow(), specifier: "%.0f")%") }
//                    maximumValueLabel: { Text("\(computeSliderHigh(), specifier: "%.0f")%") }
//                    onEditingChanged: { editing in
//                        isEditing = editing }
//                    Divider()
//                    Text(
//                        state
//                            .units == .mgdL ?
//                            "Half Basal Exercise Target at: \(state.computeHBT().formatted(.number)) mg/dl" :
//                            "Half Basal Exercise Target at: \(state.computeHBT().asMmolL.formatted(.number.grouping(.never).rounded().precision(.fractionLength(1)))) mmol/L"
//                    )
//                    .foregroundColor(.secondary)
//                    .font(.caption).italic()
//                } else {
//                    Text(
//                        "You have not enabled the proper Preferences to change sensitivity with chosen TempTarget. Verify Autosens Max > 1 & lowTT lowers Sens is on for lowTT's. For high TTs check highTT raises Sens is on (or Exercise Mode)!"
//                    )
//                    .font(.caption).italic()
//                    .fixedSize(horizontal: false, vertical: true)
//                    .multilineTextAlignment(.leading)
//                }
//            }
//        }

        var customSectionView: some View {
            Section {
                VStack {
                    Text("Carb Profile")
                    Picker("", selection: $state.carbProfileSelection) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .accentColor(.secondary)

                HStack {
                    Text("Target")
                    Spacer()
                    DecimalTextField("Unchanged", value: $state.low, formatter: formatter, cleanInput: true)
                    Text(state.units.rawValue).foregroundColor(.secondary)
                }

                HStack {
                    Text("Duration")
                    Spacer()
                    DecimalTextField("0", value: $state.duration, formatter: formatter, cleanInput: true)
                    Text("minutes").foregroundColor(.secondary)
                }

//                DatePicker("Date", selection: $state.date)
                HStack {
                    Spacer() // Pushes the button to the center from the left
                    Button(action: { isPromptPresented = true }) {
                        Text("Save as Preset")
                    }
                    Spacer() // Pushes the button to the center from the right
                }
            }
        }

        var presetNamePopoverView: some View {
            Form {
                Section(header: Text("")) {}
                Section(
                    header:
                    HStack {
                        Spacer()
                        Text("Enter preset name")
                        Spacer()
                    }
                ) {
                    TextField("Name", text: $state.newPresetName)
                        .multilineTextAlignment(.center)
                    HStack {
                        Spacer() // Pushes the button to the center
                        Button(action: { state.save()
                            isPromptPresented = false }) {
                            Text("Save")
                        }
                        Spacer() // Pushes the button to the center
                    }
                    HStack {
                        Spacer() // Pushes the button to the center
                        Button(action: { isPromptPresented = false }) {
                            Text("Cancel")
                        }
                        Spacer() // Pushes the button to the center
                    }
                }
            }
        }

        private func presetView(for preset: TempTarget) -> some View {
            var low = preset.targetBottom
            var high = preset.targetTop
            if state.units == .mmolL {
                low = low?.asMmolL
                high = high?.asMmolL
            }
            return HStack {
                VStack {
                    HStack {
                        Text(preset.displayName)
                        Spacer()
                    }
                    HStack(spacing: 2) {
                        if low == 0 {
                            Text("Target unchanged,")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        } else {
                            Text(
                                "Target \(formatter.string(from: (low ?? 0) as NSNumber)!)," // - \(formatter.string(from: (high ?? 0) as NSNumber)!)"
                            )
                            .foregroundColor(.secondary)
                            .font(.caption)
                            Text(state.units.rawValue)
                                .foregroundColor(.secondary)
                                .font(.caption)
                            /* Text("for")
                                .foregroundColor(.secondary)
                                .font(.caption) */
                        }
                        Text("\(formatter.string(from: preset.duration as NSNumber)!)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Text("minute duration")
                            .foregroundColor(.secondary)
                            .font(.caption)

                        Spacer()
                    }.padding(.top, 2)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    state.enactPreset(id: preset.id)
                }

                Image(systemName: "xmark.circle").foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .padding(.vertical)
                    .onTapGesture {
                        removeAlert = Alert(
                            title: Text("Are you sure?"),
                            message: Text("Delete preset \"\(preset.displayName)\""),
                            primaryButton: .destructive(Text("Delete"), action: { state.removePreset(id: preset.id) }),
                            secondaryButton: .cancel()
                        )
                        isRemoveAlertPresented = true
                    }
                    .alert(isPresented: $isRemoveAlertPresented) {
                        removeAlert!
                    }
            }
        }

//        func computeSliderLow() -> Double {
//            var minSens: Double = 15
//            var target = state.low
//            if state.units == .mmolL {
//                target = Decimal(round(Double(state.low.asMgdL))) }
//            if target == 0 { return minSens }
//            if target < 100 ||
//                (
//                    !state.settingsManager.preferences.highTemptargetRaisesSensitivity && !state.settingsManager.preferences
//                        .exerciseMode
//                ) { minSens = 100 }
//            return minSens
//        }

//        func computeSliderHigh() -> Double {
//            var maxSens = Double(state.maxValue * 100)
//            if state.use_autoISF {
//                maxSens = Double(state.maxValueAS * 100)
//            }
//            var target = state.low
//            if target == 0 { return maxSens }
//            if state.units == .mmolL {
//                target = Decimal(round(Double(state.low.asMgdL))) }
//            if target > 100 || !state.settingsManager.preferences.lowTemptargetLowersSensitivity { maxSens = 100 }
//            return maxSens
//        }
    }
}
