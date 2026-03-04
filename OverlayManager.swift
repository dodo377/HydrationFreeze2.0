import SwiftUI
import AppKit
import CoreImage.CIFilterBuiltins
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
    @State private var timeRemaining: Double = 0
    
    private var progressFraction: Double {
        let total = max(0.1, totalDuration)
        let clamped = min(max(timeRemaining, 0), total)
        return clamped / total
    }
    
    private var totalDuration: Double {
        max(0.1, Double(freezeSeconds))
    }
    
    @State private var motivationMessage: String = "Zeit für einen Schluck!"
    
    var onFinished: () -> Void
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // Liste der Motivationssprüche
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

    private var headerSection: some View {
        VStack(spacing: 15) {
            Image(systemName: "drop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .symbolEffect(.bounce, value: glassesDrunk)

            Text(glassesDrunk >= 10 ? "Tagesziel erreicht! 🎉" : motivationMessage)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .animation(.spring(), value: motivationMessage)

            if glassesDrunk >= 10 {
                Text("Du hast heute 2,0 Liter getrunken. Wahnsinn!")
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

                let valueString = String(format: "%.1f", Double(index + 1) * 0.2)
                Text(valueString)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.plain)
        .disabled(glassesDrunk != index)
    }

    private var glassesRow: some View {
        HStack(spacing: 12) {
            ForEach(0..<10) { index in
                glassButton(index: index)
            }

            if glassesDrunk >= 10 {
                Button(action: {
                    addWater()
                }) {
                    VStack(spacing: 5) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.green)
                            .symbolEffect(.bounce, value: glassesDrunk)

                        let nextValueString = String(format: "%.1f", Double(glassesDrunk + 1) * 0.2)
                        Text(nextValueString)
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
            if let qrImage = generateQRCode(from: "shortcuts://run-shortcut?name=WasserLog") {
                Image(nsImage: qrImage)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 90, height: 90)
                    .background(Color.white)
                    .cornerRadius(8)
            }

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

    // Funktion zum Aktualisieren der Nachricht
    func updateMessage() {
        if glassesDrunk >= 10 {
            motivationMessage = "Wahnsinn! Du bist über dem Ziel! 🏆"
        } else if glassesDrunk > 0 {
            motivationMessage = quotes[glassesDrunk - 1]
        }
    }
    
    // Adds one glass (0.2L) and updates the message
    private func addWater() {
        glassesDrunk += 1
        updateMessage()
    }

    // QR-Generator (wie gehabt...)
    func generateQRCode(from string: String) -> NSImage? {
        let data = string.data(using: .ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            let context = CIContext()
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return NSImage(cgImage: cgImage, size: NSSize(width: 90, height: 90))
            }
        }
        return nil
    }
}

