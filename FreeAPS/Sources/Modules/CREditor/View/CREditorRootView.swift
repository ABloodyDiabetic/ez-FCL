import SwiftUI
import Swinject

extension CREditor {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()
        @State private var editMode = EditMode.inactive
        @State private var activePickerIndex: Int? = nil

        @Environment(\.colorScheme) var colorScheme
        var color: LinearGradient {
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

        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.timeStyle = .short
            return formatter
        }

        private var rateFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }

        var body: some View {
            Form {
                Section(header: Text("")) {}
                Section(header: Text("")) {}
                Section(
                    header:
                    HStack {
                        Spacer()
                        Text("Carb Ratio").textCase(nil)
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                ) {}
                Section {
                    list
                }
                Section {
                    Button {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        state.save()
                    }
                    label: {
                        Text("Save").frame(maxWidth: .infinity)
                    }
                    .disabled(state.items.isEmpty)
                }
            }
            .scrollContentBackground(.hidden).background(color)
            .onAppear(perform: configureView)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.automatic)
            .environment(\.editMode, $editMode)
            .onAppear {
                state.validate()
            }
        }

        private func pickers(for index: Int) -> some View {
            GeometryReader { geometry in
                VStack {
                    HStack(spacing: 0) {
                        Picker(selection: $state.items[index].rateIndex, label: EmptyView()) {
                            ForEach(0 ..< state.rateValues.count, id: \.self) { i in
                                Text(
                                    (
                                        self.rateFormatter
                                            .string(from: state.rateValues[i] as NSNumber) ?? ""
                                    ) + " g/U"
                                ).tag(i)
                            }
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                        .clipped()
                    }
                }
            }
        }

        private var list: some View {
            List {
                ForEach(state.items.indexed(), id: \.1.id) { index, item in
                    VStack(alignment: .leading) {
                        Button(action: {
                            // Toggle picker visibility
                            self.activePickerIndex = (self.activePickerIndex == index ? nil : index)
                        }) {
                            HStack {
                                Spacer()
                                Text("\(rateFormatter.string(from: state.rateValues[item.rateIndex] as NSNumber) ?? "0") g/U")
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)

                        // Only show picker if this item is the active one
                        if activePickerIndex == index {
                            Picker(selection: $state.items[index].rateIndex, label: Text("Select Rate")) {
                                ForEach(0 ..< state.rateValues.count, id: \.self) { i in
                                    Text(self.rateFormatter.string(from: state.rateValues[i] as NSNumber) ?? "" + " g/U")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                    }
                }
            }
        }
    }
}
