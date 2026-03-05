# Changelog

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt der [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.1] (Aktuelle Version)
### Hinzugefügt
- Einstellbare Glasgröße (100ml - 1000ml).
- Individuelles Tagesziel-Limit (dynamische RuleMark im Chart).
- Automatische Berechnung der benötigten Glasanzahl in den Einstellungen.

### Geändert
- Overlay-Logik von statischen 200ml auf dynamische `@AppStorage`-Werte umgestellt.
- CSV-Export nutzt nun die konfigurierten Volumen-Werte.
- Refactoring der `SettingsView` für bessere Übersicht.

## [1.4.0]

### Hinzugefügt
- **Unbegrenztes Tracking (Bonus-Gläser):** Einführung eines permanent sichtbaren, grünen Plus-Buttons (`plus.circle.fill`), um Wasser über das ursprüngliche 2,0L-Tagesziel hinaus zu loggen. Das Design bleibt dabei konsistent zu den Standard-Gläsern.
- **Echtzeit-Statistiken:** Die Chart-Ansicht und der CSV-Export berechnen nun zur Laufzeit den heutigen Live-Wert (`glassesDrunk`) in Kombination mit der Historie. Der aktuelle Tagesfortschritt (z.B. 1,4 L) ist ab sofort sofort sichtbar, ohne auf den Tageswechsel warten zu müssen.
- **Statischer QR-Code:** Die rechenintensive, dynamische QR-Code-Generierung (`CIFilter`) wurde durch ein performantes, statisches Bild-Asset (via qr.io) ersetzt, um das UI-Design aufzuwerten.
- **Wake-from-Sleep Erkennung:** Der `AppDelegate` nutzt nun `NSWorkspace.didWakeNotification`, um den automatischen Tages-Reset direkt nach dem Aufwecken des Macs (z. B. am nächsten Morgen) zuverlässig auszuführen.
- **Umfassende Testdokumentation:** Einführung einer ISTQB-konformen Testdokumentation zur Qualitätssicherung.

### Behoben
- **Kritischer Datums-Bug (Reset-Logik):** Der Tagesvergleich nutzt nun ein festes ISO-8601 Format (`yyyy-MM-dd`) anstelle von `DateFormatter.localizedString`. Dies behebt den Fehler, dass der Reset bei unterschiedlichen macOS-Spracheinstellungen nicht fehlerfrei ausgelöst wurde.
- **Sicherer Datenspeicher:** Ein potenziell absturzverursachendes "Force Unwrap" (`!`) beim Decodieren der `historyJSON` wurde entfernt.
- **CSV-Formatierung:** Liter-Werte im CSV-Export verwenden jetzt das Komma `,` statt dem Punkt `.`, damit sie in europäischen Tabellenkalkulationen (Excel/Numbers) sofort als Zahl erkannt werden.

## [1.3.0] - Dokumentations- & Logik-Sync

### Hinzugefügt
- **Vollständiger Dokumentations-Abgleich:** Das Pflichtenheft wurde exakt an die Anforderungen des Lastenhefts angepasst.
- **Traceability Matrix:** Hinzufügen von Test-Szenarien und Abnahmekriterien in das Pflichtenheft, um die funktionalen Anforderungen überprüfbar zu machen.
- **Erweiterter CSV-Export:** Integration des `NSSavePanel` für einen nutzerfreundlichen Dialog zur Speicherung der Trinkhistorie.

### Geändert
- **Datenhygiene:** Die Logik der Historie wurde so angepasst, dass Einträge, die älter als 14 Tage sind, automatisch aus den `UserDefaults` gelöscht werden (`history.removeFirst()`).

## [1.2.0] - Codebase Refactoring

### Geändert
- **Zentralisierung der Logik:** Die Steuerung des Overlays und der Fenster-Instanzen wurde in den `OverlayManager` ausgelagert.
- **Multi-Monitor-Support:** Die Schleife über `NSScreen.screens` wurde optimiert, um sicherzustellen, dass das `.screenSaver` Level-Panel alle aktiven Displays abdeckt.
- **Haptisches Feedback:** Integration des `NSHapticFeedbackManager` zur Bestätigung von Klicks auf die Wassertropfen.

## [1.1.0] - Zukunftsplanung & Wartung

### Hinzugefügt
- **Wartungskonzept:** Kapitel zur Fehlerprotokollierung und zum Monitor-Wechsel-Management in die Dokumentation aufgenommen.
- **Projekt-Roadmap:** Planung zukünftiger Erweiterungen definiert (Apple Watch Integration, iCloud Sync via CloudKit, dynamische Ziele nach Körpergewicht und macOS-Widgets).

## [1.0.0] - Initiale Version

### Hinzugefügt
- **Basis-Funktionalität:** Menüleisten-App (Agent-App ohne Dock-Icon) zur Erinnerung an die Wasseraufnahme.
- **Overlay-Sperre:** Zeitgesteuerte Vollbild-Verdunkelung mit einstellbaren Intervallen (5-120 Min.) und Sperrdauern (5-60 Sek.).
- **10-Gläser-Tracker:** Interaktives Klicken von 10 Wassertropfen (à 0,2L) zum Erreichen des 2,0L Tagesziels.
- **Motivations-Engine:** 10 dynamische Sprüche, die sich je nach Fortschritt ändern.
- **Basis-Statistik:** Balkendiagramm via Swift Charts zur Anzeige der gespeicherten Historie.
