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
    
    // MARK: - Persistence
    @AppStorage("intervalMinutes") var intervalMinutes = 30
    @AppStorage("lastUpdateDay") var lastUpdateDay = ""
    @AppStorage("glassesDrunk") var glassesDrunk = 0 // Direktzugriff für UI-Reaktivität

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialer Check beim Start
        checkNewDay()
        startTimer()
        
        // 1. Beobachtet das Aufwachen des Macs aus dem Ruhezustand
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkNewDay()
        }
        
        // 2. WICHTIG: Beobachtet den systemweiten Datumswechsel (Mitternacht-Trigger)
        NotificationCenter.default.addObserver(
            forName: .NSCalendarDayChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkNewDay()
        }
    }

    /// Prüft, ob seit dem letzten Log ein neuer Tag angebrochen ist
    func checkNewDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        // Erster Start der App überhaupt: Nur Datum setzen, kein Reset nötig
        if lastUpdateDay == "" {
            lastUpdateDay = today
            return
        }

        // Wenn gespeichertes Datum != heute -> Ein neuer Tag ist angebrochen!
        if lastUpdateDay != today {
            print("Neuer Tag erkannt (\(today)). Starte Archivierung und Reset...")
            
            // 1. Archivieren: Nutze den aktuellen Wert von glassesDrunk
            let amount = Double(glassesDrunk) * 0.2
            
            // 2. Datum von gestern berechnen
            let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            
            // 3. In die Historie schreiben
            saveToHistory(entry: HydrationLog(date: yesterdayDate, amount: amount))
            
            // 4. RESET: Durch @AppStorage wird die UI überall sofort auf 0 gesetzt
            self.glassesDrunk = 0
            
            // 5. Speicherdatum auf heute aktualisieren
            lastUpdateDay = today
        }
    }

    func saveToHistory(entry: HydrationLog) {
        let jsonString = UserDefaults.standard.string(forKey: "historyJSON") ?? "[]"
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        
        var history = (try? JSONDecoder().decode([HydrationLog].self, from: jsonData)) ?? []
        history.append(entry)
        
        // Behalte nur die letzten 14 Tage
        if history.count > 14 {
            history.removeFirst()
        }
        
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(String(data: encoded, encoding: .utf8), forKey: "historyJSON")
        }
    }

    func startTimer() {
        timer?.invalidate()
        // Nutze weak self, um Memory Leaks zu vermeiden
        timer = Timer.scheduledTimer(withTimeInterval: Double(intervalMinutes) * 60, repeats: true) { [weak self] _ in
            self?.triggerFreeze()
        }
    }

    @objc func triggerFreeze() {
        // Sicherheits-Check: Falls der Mac über Mitternacht an war und der Timer feuert
        checkNewDay()
        overlayManager.showOverlays()
    }
}
