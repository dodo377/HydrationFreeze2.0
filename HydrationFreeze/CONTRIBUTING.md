# Mitwirken bei HydrationFreeze (Contributing)

Vielen Dank für dein Interesse, HydrationFreeze zu verbessern! 💧

## Lokale Entwicklung & Kompilierung

Wenn du dieses Projekt klonst und in Xcode baust, beachte bitte diese zwingenden Voraussetzungen für die Overlay-Architektur:

1. **App Sandbox:** Gehe in Xcode auf das Target `HydrationFreeze` -> `Signing & Capabilities` und stelle sicher, dass die **App Sandbox DEAKTIVIERT** ist. Das ist zwingend erforderlich, damit `NSPanel` auf dem Level `.screenSaver` operieren darf und Vollbild-Apps überlagern kann.
2. **Agent App:** In der `Info.plist` ist `Application is agent (UIElement)` auf `YES` gesetzt. Wenn du die App startest, erscheint kein Fenster und kein Dock-Icon. Du findest sie oben in der macOS-Menüleiste.

## Code-Stil & Pull Requests

- Bitte nutze Swift 5.10+ und achte auf die Kompatibilität mit macOS 14.0.
- Aktualisiere bei UI-Änderungen das PFLICHTENHEFT.md, damit die Dokumentation synchron mit dem Code bleibt.
- Öffne für größere Features zunächst ein "Issue", um die Idee zu diskutieren, bevor du einen Pull Request (PR) erstellst.
