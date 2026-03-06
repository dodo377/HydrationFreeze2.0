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
            
            // Hier wird die Schließ-Logik als Closure übergeben
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
        self.overlayWindows.forEach { window in
            window.orderOut(nil)
        }
        self.overlayWindows.removeAll()
    }
}

struct OverlayView: View {
    @AppStorage("freezeSeconds") var freezeSeconds = 15
    @AppStorage("glassesDrunk") var glassesDrunk = 0
    @AppStorage("selectedGlassSize") private var selectedGlassSize: Int = 250
    @AppStorage("dailyGoal") private var dailyGoal: Int = 2000
    
    @State private var timeRemaining: Double = 0
    @State private var motivationMessage: String = "Zeit für einen Schluck!"
    
    var onFinished: () -> Void
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // --- DYNAMISCHE LOGIK ---

    private var glassesNeededForGoal: Int {
        max(1, Int(Double(dailyGoal) / Double(selectedGlassSize)))
    }

    private var currentTotalML: Int {
        glassesDrunk * selectedGlassSize
    }
    
    private var isGoalReached: Bool {
        currentTotalML >= dailyGoal
    }

    private var progressFraction: Double {
        let total = max(0.1, Double(freezeSeconds))
        return min(timeRemaining / total, 1.0)
    }

    private var dynamicIconSize: CGFloat {
        let totalIcons = max(glassesNeededForGoal, glassesDrunk)
        if totalIcons <= 8 { return 45 }
        if totalIcons <= 12 { return 35 }
        if totalIcons <= 20 { return 25 }
        return 20
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
            Image(systemName: isGoalReached ? "checkmark.circle.fill" : "drop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(isGoalReached ? .green : .blue)
                .symbolEffect(.bounce, value: glassesDrunk)

            Text(isGoalReached ? "Tagesziel erreicht! 🎉" : motivationMessage)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if isGoalReached {
                Text("Du hast heute \(Double(currentTotalML)/1000.0, specifier: "%.1f") Liter getrunken. Wahnsinn!")
                    .font(.title3)
                    .foregroundColor(.green)
            }
        }
    }

    private func glassButton(index: Int) -> some View {
        Button(action: {
            if glassesDrunk == index { addWater() }
        }) {
            VStack(spacing: 5) {
                Image(systemName: index < glassesDrunk ? "drop.fill" : "drop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: dynamicIconSize, height: dynamicIconSize)
                    .foregroundColor(index < glassesDrunk ? .blue : .white.opacity(0.2))
                    .symbolEffect(.pulse, value: glassesDrunk == index)

                Text("\(Double(index + 1) * Double(selectedGlassSize) / 1000.0, specifier: "%.2f")")
                    .font(.system(size: dynamicIconSize * 0.3, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.plain)
        .disabled(glassesDrunk != index)
    }

    private var glassesRow: some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: glassesNeededForGoal > 10 ? 8 : 15) {
                    ForEach(0..<max(glassesNeededForGoal, glassesDrunk), id: \.self) { index in
                        glassButton(index: index)
                    }

                    Button(action: { addWater() }) {
                        VStack(spacing: 5) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: dynamicIconSize, height: dynamicIconSize)
                                .foregroundColor(.green)
                            
                            Text("\(Double(glassesDrunk + 1) * Double(selectedGlassSize) / 1000.0, specifier: "%.2f")")
                                .font(.system(size: dynamicIconSize * 0.3, design: .monospaced))
                                .foregroundColor(.green)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.05)))
            .frame(maxWidth: 700)
        }
    }

    private var qrAndProgress: some View {
        VStack(spacing: 20) {
            Image("QRCode")
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 90, height: 90)
                .padding(8)
                .background(Color.white)
                .cornerRadius(12)

            ProgressView(value: progressFraction)
                .tint(.blue)
                .frame(width: 300)
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
    }

    var body: some View {
        VStack(spacing: 40) {
            headerSection
            glassesRow
            qrAndProgress
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.96))
        .onAppear {
            timeRemaining = 0
            updateMessage()
        }
        .onReceive(timer) { _ in
            let total = max(0.1, Double(freezeSeconds))
            if timeRemaining < total {
                timeRemaining += 0.1
            } else {
                onFinished()
            }
        }
    }

    func updateMessage() {
        if isGoalReached {
            motivationMessage = "Wahnsinn! Du bist über dem Ziel! 🏆"
        } else {
            let quoteIndex = min(glassesDrunk, quotes.count - 1)
            motivationMessage = quotes[quoteIndex]
        }
    }
        
    private func addWater() {
        glassesDrunk += 1
        updateMessage()
        
        // --- FIX FÜR DEF-06 ---
        // Schließt das Overlay sofort nach der Interaktion
        onFinished()
    }
}
