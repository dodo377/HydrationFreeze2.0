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
        
        // WICHTIG: Beobachtet das Aufwachen des Macs
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.checkNewDay()
        }
    }

    func checkNewDay() {
        // ISO-Format ist immun gegen Spracheinstellungen (immer "2024-03-04")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        // Erster Start der App überhaupt
        if lastUpdateDay == "" {
            lastUpdateDay = today
            return
        }

        // Vergleich: Ist das gespeicherte Datum ungleich heute?
        if lastUpdateDay != today {
            // 1. Hole den Wert von gestern direkt aus den UserDefaults
            let glassesYesterday = UserDefaults.standard.integer(forKey: "glassesDrunk")
            let amount = Double(glassesYesterday) * 0.2
            
            // 2. Berechne das Datum von gestern für den Log
            let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            
            // 3. Archivieren
            saveToHistory(entry: HydrationLog(date: yesterdayDate, amount: amount))
            
            // 4. RESET: Setze Zähler auf 0
            UserDefaults.standard.set(0, forKey: "glassesDrunk")
            
            // 5. Speicherdatum aktualisieren
            lastUpdateDay = today
            print("Neuer Tag erkannt: Reset durchgeführt.")
        }
    }

    func saveToHistory(entry: HydrationLog) {
        let jsonString = UserDefaults.standard.string(forKey: "historyJSON") ?? "[]"
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        
        // Sicherer Decode ohne "!"
        var history = (try? JSONDecoder().decode([HydrationLog].self, from: jsonData)) ?? []
        history.append(entry)
        
        // Behalte nur die letzten 14 Tage (Lastenheft-Anforderung)
        if history.count > 14 {
            history.removeFirst()
        }
        
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
