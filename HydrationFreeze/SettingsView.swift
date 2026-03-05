import SwiftUI
import Charts
internal import UniformTypeIdentifiers

struct SettingsView: View {
    @AppStorage("intervalMinutes") var intervalMinutes = 30
    @AppStorage("freezeSeconds") var freezeSeconds = 15
    @AppStorage("glassesDrunk") var glassesDrunk = 0
    @AppStorage("historyJSON") var historyJSON: String = "[]"
    @AppStorage("selectedGlassSize") private var selectedGlassSize: Int = 250
    @AppStorage("dailyGoal") private var dailyGoal: Int = 2000

    var body: some View {
        TabView {
            Form {
                Section("Intervalle") {
                    Stepper("Erinnerung alle \(intervalMinutes) Min.", value: $intervalMinutes, in: 5...120)
                    Stepper("Sperre für \(freezeSeconds) Sek.", value: $freezeSeconds, in: 5...60)
                }
                
                Section(header: Text("Trink-Konfiguration")) {
                    // Stepper für die Glasgröße
                    Stepper(value: $selectedGlassSize, in: 100...1000, step: 50) {
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                            Text("Glasgröße:")
                            Spacer()
                            Text("\(selectedGlassSize) ml")
                                .fontWeight(.bold)
                        }
                    }
                    
                    // Stepper für das Tagesziel
                    Stepper(value: $dailyGoal, in: 1000...5000, step: 100) {
                        HStack {
                            Image(systemName: "target")
                                .foregroundColor(.red)
                            Text("Tagesziel:")
                            Spacer()
                            Text("\(String(format: "%.1f", Double(dailyGoal)/1000.0)) L")
                                .fontWeight(.bold)
                        }
                    }

                    let glassesNeeded = Double(dailyGoal) / Double(selectedGlassSize)
                    Text("Das entspricht ca. \(String(format: "%.1f", glassesNeeded)) Gläsern pro Tag.")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
        .frame(width: 500, height: 480) // Höhe leicht angepasst für das neue Feld
    }

    private var chartSection: some View {
        let goalInLiters = Double(dailyGoal) / 1000.0
        
        return Chart {
            ForEach(getHistory()) { log in
                BarMark(x: .value("Tag", log.date, unit: .day), y: .value("L", log.amount))
                    .foregroundStyle(log.amount >= goalInLiters ? Color.green.gradient : Color.blue.gradient)
            }
            // Die Ziel-Linie ist jetzt dynamisch!
            RuleMark(y: .value("Ziel", goalInLiters))
                .lineStyle(StrokeStyle(dash: [5]))
                .foregroundStyle(.red)
                .annotation(position: .top, alignment: .trailing) {
                    Text("Ziel: \(String(format: "%.1f", goalInLiters))L")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
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
            Image("QRCode")
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 65, height: 65)
                .background(Color.white)
                .cornerRadius(8)
        }.padding().background(Color.gray.opacity(0.1)).cornerRadius(10)
    }

    func getHistory() -> [HydrationLog] {
        let data = historyJSON.data(using: .utf8) ?? Data()
        var history = (try? JSONDecoder().decode([HydrationLog].self, from: data)) ?? []
        
        // BERECHNUNG GEÄNDERT: Nutzt jetzt selectedGlassSize statt 0.2
        let todayAmount = Double(glassesDrunk) * Double(selectedGlassSize) / 1000.0
        let today = Date()
        
        if let lastIndex = history.indices.last,
           Calendar.current.isDate(history[lastIndex].date, inSameDayAs: today) {
            history[lastIndex] = HydrationLog(date: today, amount: todayAmount)
        } else {
            history.append(HydrationLog(date: today, amount: todayAmount))
        }
        
        return history
    }

    func exportCSV() {
        let history = getHistory()
        var csv = "Datum;Liter\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        for entry in history {
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
