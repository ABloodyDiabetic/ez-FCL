import UIKit
import BackgroundTasks  // Import the BackgroundTasks framework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Add a static shared instance to allow easy access to the AppDelegate
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register the background tasks
        registerBackgroundTasks()
        return true
    }

    private func registerBackgroundTasks() {
        // Registering the background task for resetting carb profiles
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.resetCarbProfile", using: nil) { task in
            // This cast is safe as long as the identifier matches
            self.handleResetCarbProfileTask(task: task as! BGAppRefreshTask)
        }
    }

    func handleResetCarbProfileTask(task: BGAppRefreshTask) {
        // Set up an expiration handler which ends the task if it takes too long
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        // Perform the reset logic
        resetCarbProfiles()

        // Indicate that the background task is completed
        task.setTaskCompleted(success: true)

        // Schedule the next execution of this task
        scheduleResetCarbProfileTask()
    }

    func scheduleResetCarbProfileTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.resetCarbProfile")
        // Set the earliest begin date for 4.5 hours later
        request.earliestBeginDate = Date(timeIntervalSinceNow: 4.5 * 3600)  // Schedule for 4.5 hours from now

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    func resetCarbProfiles() {
        // Actual logic to reset carb profiles
        updateCarbProfileSettings(enableLowCarb: true)
    }

    // Example updateCarbProfileSettings implementation (pseudo-code)
    func updateCarbProfileSettings(enableLowCarb: Bool) {
        // Update and save preferences accordingly
    }

    // Remaining application delegate methods, like entering background, becoming active, etc., as needed...
}
