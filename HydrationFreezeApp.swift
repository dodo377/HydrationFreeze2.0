import SwiftUI

@main
struct HydrationApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Hydration", systemImage: "drop.fill") {
            Button("Jetzt trinken (Test)") {
                appDelegate.triggerFreeze()
            }
            Divider()
            SettingsLink {
                Text("Einstellungen...")
            }
            .keyboardShortcut(",", modifiers: .command)
            Divider()
            Button("Beenden") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }

        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var timer: Timer?
    let overlayManager = OverlayManager()
    
    @AppStorage("intervalMinutes") var intervalMinutes = 30
    @AppStorage("lastUpdateDay") var lastUpdateDay = ""

    func applicationDidFinishLaunching(_ notification: Notification) {
        checkNewDay()
        startTimer()
    }

    func checkNewDay() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        if lastUpdateDay != "" && lastUpdateDay != today {
            // Historie sichern
            let amount = Double(UserDefaults.standard.integer(forKey: "glassesDrunk")) * 0.2
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            saveToHistory(entry: HydrationLog(date: yesterday, amount: amount))
            
            // Reset
            UserDefaults.standard.set(0, forKey: "glassesDrunk")
        }
        lastUpdateDay = today
    }

    func saveToHistory(entry: HydrationLog) {
        let json = UserDefaults.standard.string(forKey: "historyJSON") ?? "[]"
        var history = (try? JSONDecoder().decode([HydrationLog].self, from: json.data(using: .utf8)!)) ?? []
        history.append(entry)
        if history.count > 14 { history.removeFirst() }
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(String(data: encoded, encoding: .utf8), forKey: "historyJSON")
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Double(intervalMinutes) * 60, repeats: true) { _ in
            self.triggerFreeze()
        }
    }

    @objc func triggerFreeze() {
        overlayManager.showOverlays()
    }
}
