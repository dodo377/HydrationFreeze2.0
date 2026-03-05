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
        
        let todayAmount = Double(glassesDrunk) * 0.2
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
