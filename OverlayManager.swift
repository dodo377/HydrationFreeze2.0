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
    var onFinished: () -> Void
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 10) {
                Image(systemName: "drop.fill").resizable().frame(width: 60, height: 60).foregroundColor(.blue).symbolEffect(.pulse)
                Text(glassesDrunk >= 10 ? "Ziel erreicht!" : "TRINK-PAUSE").font(.system(size: 48, weight: .black, design: .rounded)).foregroundColor(.white)
            }

            HStack(spacing: 15) {
                ForEach(0..<10) { index in
                    Button(action: {
                        if glassesDrunk == index {
                            glassesDrunk += 1
                            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                        }
                    }) {
                        Image(systemName: index < glassesDrunk ? "drop.fill" : "drop")
                            .resizable().frame(width: 40, height: 40)
                            .foregroundColor(index < glassesDrunk ? .blue : .white.opacity(0.2))
                    }.buttonStyle(.plain)
                }
            }

            if let qr = generateQRCode(from: "shortcuts://run-shortcut?name=WasserLog") {
                VStack {
                    Image(nsImage: qr).resizable().interpolation(.none).frame(width: 100, height: 100).background(Color.white).cornerRadius(8)
                    Text("iPhone Health Log").font(.caption).foregroundColor(.gray)
                }
            }

            ProgressView(value: timeRemaining, total: Double(freezeSeconds)).frame(width: 300).tint(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.95))
        .onReceive(timer) { _ in
            if timeRemaining < Double(freezeSeconds) { timeRemaining += 0.1 } else { onFinished() }
        }
    }

    func generateQRCode(from string: String) -> NSImage? {
        let data = string.data(using: .ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        if let output = filter.outputImage {
            let transformed = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            let context = CIContext()
            if let cgImage = context.createCGImage(transformed, from: transformed.extent) {
                return NSImage(cgImage: cgImage, size: NSSize(width: 100, height: 100))
            }
        }
        return nil
    }
}
