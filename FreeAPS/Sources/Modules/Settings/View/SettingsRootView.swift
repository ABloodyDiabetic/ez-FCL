import HealthKit
import SwiftUI
import Swinject

extension Settings {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()
        @State private var showShareSheet = false

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
                    Toggle("Closed loop", isOn: $state.closedLoop)
                    // Toggle("Activate ezFCL", isOn: $state.autoisf)
                }
                header: {
                    if let expirationDate = Bundle.main.profileExpiration {
                        Text(
                            "ez-FCL v\(state.versionNumber) (\(state.buildNumber))\nBranch: \(state.branch)\n\(state.copyrightNotice)" +
                                "\nBuild Expires: " + expirationDate
                        ).textCase(nil)
                    } else {
                        Text(
                            "ez-FCL v\(state.versionNumber) (\(state.buildNumber))\nBranch: \(state.branch)\n\(state.copyrightNotice)"
                        )
                    }
                }

                Section {
                    Text("ezFCL").navigationLink(to: .autoISFConf, from: self)
                    Text("Oref1").navigationLink(to: .preferencesEditor, from: self)
                    Text("AIMI B30").navigationLink(to: .B30Conf, from: self)
//                    Text("Ketoacidosis Protection").navigationLink(to: .KetoConfig, from: self)
//                    Text("Dynamic ISF").navigationLink(to: .dynamicISF, from: self)
//                    Text("Dynamic ISF").navigationLink(to: .dynamicISF, from: self)
//                    Text("Autotune").navigationLink(to: .autotuneConfig, from: self)
                } header: { Text("Algorithm") }

                Section {
                    Text("Target Glucose").navigationLink(to: .targetsEditor, from: self)
                    Text("Pump Settings").navigationLink(to: .pumpSettingsEditor, from: self)
                    Text("Basal Profile").navigationLink(to: .basalProfileEditor, from: self)
                    Text("Insulin Sensitivities").navigationLink(to: .isfEditor, from: self)
                    Text("Carb Ratios").navigationLink(to: .crEditor, from: self)
                } header: { Text("Configuration") }

                Section {
                    Text("Pump").navigationLink(to: .pumpConfig, from: self)
                    Text("CGM").navigationLink(to: .cgm, from: self)
                    Text("Watch").navigationLink(to: .watch, from: self)
                } header: { Text("Devices") }

                Section {
//                    Text("Contact Image").navigationLink(to: .contactTrick, from: self)
                    Text("Bolus Calculator").navigationLink(to: .bolusCalculatorConfig, from: self)
                    Text("Fat And Protein Conversion").navigationLink(to: .fpuConfig, from: self)
                    Text("Notifications").navigationLink(to: .notificationsConfig, from: self)
                    Text("UI/UX Settings").navigationLink(to: .statisticsConfig, from: self)
                    Text("Contact trick").navigationLink(to: .contactTrick, from: self)
                    Text("Nightscout").navigationLink(to: .nighscoutConfig, from: self)
                    if HKHealthStore.isHealthDataAvailable() {
                        Text("Apple Health").navigationLink(to: .healthkit, from: self)
                    }
                    Text("Preferences").navigationLink(to: .configEditor(file: OpenAPS.Settings.preferences), from: self)
//                    Text("App Icons").navigationLink(to: .iconConfig, from: self)
                } header: { Text("Features") }

                Section {
                    Toggle("Enable", isOn: $state.enableMiddleware)
                    Text("Middleware").navigationLink(to: .configEditor(file: OpenAPS.Middleware.determineBasal), from: self)
                } header: { Text("Middleware") }

                Section {
                    Toggle("Advanced options", isOn: $state.debugOptions)
                    if state.debugOptions {
                        Group {
                            HStack {
                                Text("NS Upload Profile and Settings")
                                Button("Upload") { state.uploadProfileAndSettings(true) }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .buttonStyle(.borderedProminent)
                            }

                            HStack {
                                Text("Delete All NS Overrides")
                                Button("Delete") { state.deleteOverrides() }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                            } /*

                             HStack {
                                 Text("Delete latest NS Override")
                                 Button("Delete") { state.deleteOverride() }
                                     .frame(maxWidth: .infinity, alignment: .trailing)
                                     .buttonStyle(.borderedProminent)
                                     .tint(.red)
                             } */
                        }
                        Group {
                            Text("Pump Settings")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.settings), from: self)
                            Text("Autosense")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.autosense), from: self)
                            Text("Pump History")
                                .navigationLink(to: .configEditor(file: OpenAPS.Monitor.pumpHistory), from: self)
                            Text("Basal profile")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.basalProfile), from: self)
                            Text("Targets ranges")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.bgTargets), from: self)
                            Text("Temp targets")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.tempTargets), from: self)
                            Text("Meal")
                                .navigationLink(to: .configEditor(file: OpenAPS.Monitor.meal), from: self)
                        }

                        Group {
                            Text("Pump profile")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.pumpProfile), from: self)
                            Text("Profile")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.profile), from: self)
                            Text("Carbs")
                                .navigationLink(to: .configEditor(file: OpenAPS.Monitor.carbHistory), from: self)
                            Text("Enacted")
                                .navigationLink(to: .configEditor(file: OpenAPS.Enact.enacted), from: self)
                            Text("Announcements")
                                .navigationLink(to: .configEditor(file: OpenAPS.FreeAPS.announcements), from: self)
                            Text("Enacted announcements")
                                .navigationLink(to: .configEditor(file: OpenAPS.FreeAPS.announcementsEnacted), from: self)
                            Text("Overrides Not Uploaded")
                                .navigationLink(to: .configEditor(file: OpenAPS.Nightscout.notUploadedOverrides), from: self)
                            Text("Autotune")
                                .navigationLink(to: .configEditor(file: OpenAPS.Settings.autotune), from: self)
                            Text("Glucose")
                                .navigationLink(to: .configEditor(file: OpenAPS.Monitor.glucose), from: self)
                        }

                        Group {
                            Text("Target presets")
                                .navigationLink(to: .configEditor(file: OpenAPS.FreeAPS.tempTargetsPresets), from: self)
                            Text("Calibrations")
                                .navigationLink(to: .configEditor(file: OpenAPS.FreeAPS.calibrations), from: self)
                            Text("Statistics")
                                .navigationLink(to: .configEditor(file: OpenAPS.Monitor.statistics), from: self)
                            Text("Edit settings json")
                                .navigationLink(to: .configEditor(file: OpenAPS.FreeAPS.settings), from: self)
                        }
                    }
                } header: { Text("Developer") }

//                Section {
//                    Toggle("Animated Background", isOn: $state.animatedBackground)
//                }

                Section {
                    Text("Share logs")
                        .onTapGesture {
                            showShareSheet = true
                        }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: state.logItems())
            }
            .scrollContentBackground(.hidden).background(color)
            .onAppear(perform: configureView)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        state.hideSettingsModal()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear(perform: {
                state.saveIfChanged()
                state.uploadProfileAndSettings(false)
            })
        }
    }
}
