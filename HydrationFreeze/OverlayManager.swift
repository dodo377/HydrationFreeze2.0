import SwiftUI
import AppKit
internal import Combine

class OverlayManager {
    var overlayWindows: [NSPanel] = []

    func showOverlays() {
        closeOverlays()
        NSApp.activate(ignoringOtherApps: true)

        for screen in NSScreen.screens {
            let panel = NSPanel(
                contentRect: screen.frame,
                styleMask: [.borderless, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            panel.level = .screenSaver
            panel.backgroundColor = NSColor.black.withAlphaComponent(0.94)
            panel.ignoresMouseEvents = false
            panel.isFloatingPanel = true
            
            let hostingView = NSHostingView(rootView: OverlayView(onFinished: {
                self.closeOverlays()
            }))
            panel.contentView = hostingView
            panel.makeKeyAndOrderFront(nil)
            panel.orderFrontRegardless()
            overlayWindows.append(panel)
        }
        NSCursor.unhide()
    }

    func closeOverlays() {
        overlayWindows.forEach { $0.close() }
        overlayWindows.removeAll()
    }
}

struct OverlayView: View {
    @AppStorage("freezeSeconds") var freezeSeconds = 15
    @AppStorage("glassesDrunk") var glassesDrunk = 0
    @AppStorage("selectedGlassSize") private var selectedGlassSize: Int = 250
    @AppStorage("dailyGoal") private var dailyGoal: Int = 2000 // Standard 2 Liter
    
    @State private var timeRemaining: Double = 0
    @State private var motivationMessage: String = "Zeit für einen Schluck!"
    
    var onFinished: () -> Void
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // Hilfsvariablen für die Berechnung
    private var currentTotalML: Int {
        glassesDrunk * selectedGlassSize
    }
    
    private var isGoalReached: Bool {
        currentTotalML >= dailyGoal
    }

    private var progressFraction: Double {
        let total = max(0.1, totalDuration)
        let clamped = min(max(timeRemaining, 0), total)
        return clamped / total
    }
    
    private var totalDuration: Double {
        max(0.1, Double(freezeSeconds))
    }
    
    let quotes = [
        "Sehr gut! Dein Körper dankt es dir. 💧",
        "Bleib hydriert! Dein Fokus wird schärfer. 🧠",
        "Jeder Schluck zählt! Weiter so. ✨",
        "Hervorragend! Du tust dir gerade etwas Gutes. 🌿",
        "Frisches Wasser, frische Energie! 🔥",
        "Du bist auf einem super Weg! 🚀",
        "Halbzeit fast geschafft! Bleib dran. 🌊",
        "Dein Stoffwechsel läuft jetzt auf Hochtouren! ⚙️",
        "Fast am Ziel! Nur noch ein bisschen. 💪",
        "Herausragend! Dein Körper ist jetzt perfekt versorgt. 💎"
    ]

    // --- VIEW KOMPONENTEN ---

    private var headerSection: some View {
        VStack(spacing: 15) {
            Image(systemName: "drop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .symbolEffect(.bounce, value: glassesDrunk)

            Text(isGoalReached ? "Tagesziel erreicht! 🎉" : motivationMessage)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .animation(.spring(), value: motivationMessage)

            if isGoalReached {
                let totalLiters = Double(currentTotalML) / 1000.0
                Text("Du hast heute \(String(format: "%.1f", totalLiters)) Liter getrunken. Wahnsinn!")
                    .font(.title3)
                    .foregroundColor(.green)
            }
        }
    }

    private func glassButton(index: Int) -> some View {
        Button(action: {
            if glassesDrunk == index {
                addWater()
            }
        }) {
            VStack(spacing: 5) {
                Image(systemName: index < glassesDrunk ? "drop.fill" : "drop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .foregroundColor(index < glassesDrunk ? .blue : .white.opacity(0.2))
                    .symbolEffect(.pulse, value: glassesDrunk == index)

                // Dynamische Anzeige der Liter pro Glas
                let liters = Double(index + 1) * Double(selectedGlassSize) / 1000.0
                Text(String(format: "%.1f", liters))
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.plain)
        .disabled(glassesDrunk != index)
    }

    private var glassesRow: some View {
        HStack(spacing: 12) {
            // Der Zusatz id: \.self löst den Fehler bei dynamischen Ranges
            ForEach(0..<max(8, glassesDrunk), id: \.self) { index in
                if index < 10 {
                    glassButton(index: index)
                }
            }

            if glassesDrunk >= 8 {
                Button(action: { addWater() }) {
                    VStack(spacing: 5) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.green)
                            .symbolEffect(.bounce, value: glassesDrunk)
                        
                        let nextLiters = Double(glassesDrunk + 1) * Double(selectedGlassSize) / 1000.0
                        Text(String(format: "%.1f", nextLiters))
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.green)
                    }
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.05)))
    }

    private var qrAndProgress: some View {
        VStack(spacing: 20) {
            Image("QRCode")
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 100, height: 100)
                .background(Color.white)
                .cornerRadius(12)
                .padding(4)
                .background(Color.white)
                .cornerRadius(16)

            ProgressView(value: progressFraction)
                .tint(.blue)
                .frame(width: 300)
        }
    }

    var body: some View {
        VStack(spacing: 35) {
            headerSection
            glassesRow
            qrAndProgress
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.96))
        .onAppear { timeRemaining = 0 }
        .onReceive(timer) { _ in
            let step: Double = 0.1
            let total = max(0.1, totalDuration)
            let newValue = timeRemaining + step
            if newValue < total {
                timeRemaining = newValue
            } else {
                timeRemaining = total
                onFinished()
            }
        }
    }

    func updateMessage() {
        if isGoalReached {
            motivationMessage = "Wahnsinn! Du bist über dem Ziel! 🏆"
        } else {
            // Wähle ein Zitat basierend auf dem Fortschritt
            let quoteIndex = min(glassesDrunk, quotes.count - 1)
            motivationMessage = quotes[quoteIndex]
        }
    }
    
    private func addWater() {
        glassesDrunk += 1
        updateMessage()
    }
}
