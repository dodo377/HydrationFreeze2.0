import SwiftUI
import Charts
internal import UniformTypeIdentifiers

struct SettingsView: View {
    @AppStorage("intervalMinutes") var intervalMinutes = 30
    @AppStorage("freezeSeconds") var freezeSeconds = 15
    @AppStorage("glassesDrunk") var glassesDrunk = 0
    @AppStorage("historyJSON") var historyJSON: String = "[]"

    var body: some View {
        TabView {
            Form {
                Section("Intervalle") {
                    Stepper("Erinnerung alle \(intervalMinutes) Min.", value: $intervalMinutes, in: 5...120)
                    Stepper("Sperre für \(freezeSeconds) Sek.", value: $freezeSeconds, in: 5...60)
                }
                Section("Daten") {
                    Button("CSV Export") { exportCSV() }
                    Button("Reset heute", role: .destructive) { glassesDrunk = 0 }
                }
            }
            .tabItem { Label("Optionen", systemImage: "gearshape") }

            VStack(spacing: 20) {
                chartSection
                Divider()
                syncSection
            }
            .padding()
            .tabItem { Label("Statistik", systemImage: "chart.bar.fill") }
        }
        .frame(width: 500, height: 450)
    }

    private var chartSection: some View {
        Chart {
            ForEach(getHistory()) { log in
                BarMark(x: .value("Tag", log.date, unit: .day), y: .value("L", log.amount))
                    .foregroundStyle(log.amount >= 2.0 ? Color.green.gradient : Color.blue.gradient)
            }
            RuleMark(y: .value("Ziel", 2.0)).lineStyle(StrokeStyle(dash: [5])).foregroundStyle(.red)
        }
        .frame(height: 150)
    }

    private var syncSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("iPhone Sync").bold()
                Text("Shortcut 'WasserLog' scannen").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            if let qr = generateQRCode(from: "shortcuts://run-shortcut?name=WasserLog") {
                Image(nsImage: qr).resizable().interpolation(.none).frame(width: 60, height: 60).background(Color.white).cornerRadius(4)
            }
        }.padding().background(Color.gray.opacity(0.1)).cornerRadius(10)
    }

    func getHistory() -> [HydrationLog] {
        let data = historyJSON.data(using: .utf8) ?? Data()
        var history = (try? JSONDecoder().decode([HydrationLog].self, from: data)) ?? []
        
        // Berechne den aktuellen Stand von HEUTE
        let todayAmount = Double(glassesDrunk) * 0.2
        let today = Date()
        
        // Prüfen, ob der letzte Eintrag in der Historie schon von heute ist
        if let lastIndex = history.indices.last,
           Calendar.current.isDate(history[lastIndex].date, inSameDayAs: today) {
            // Falls ja, aktualisiere den Wert (falls du z.B. gerade getrunken hast)
            history[lastIndex] = HydrationLog(date: today, amount: todayAmount)
        } else {
            // Falls heute noch gar nicht in der Historie ist, füge es für die Anzeige hinzu
            history.append(HydrationLog(date: today, amount: todayAmount))
        }
        
        return history
    }
    
    func generateQRCode(from string: String) -> NSImage? {
        let data = string.data(using: .ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        if let output = filter.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(output, from: output.extent) {
                return NSImage(cgImage: cgImage, size: NSSize(width: 60, height: 60))
            }
        }
        return nil
    }

    func exportCSV() {
        let history = getHistory() // Nutzt jetzt die kombinierte Liste inkl. heute
        var csv = "Datum;Liter\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        for entry in history {
            // Formatiert die Liter-Zahl mit Komma für Excel/Numbers
            let amountString = String(format: "%.1f", entry.amount).replacingOccurrences(of: ".", with: ",")
            csv += "\(dateFormatter.string(from: entry.date));\(amountString)\n"
        }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.commaSeparatedText]
        savePanel.nameFieldStringValue = "Hydration_Export.csv"
        
        savePanel.begin { result in
            if result == .OK, let url = savePanel.url {
                try? csv.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
}
