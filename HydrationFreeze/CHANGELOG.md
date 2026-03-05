[← Zurück zur Übersicht](../README.md)

# Changelog

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt der [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.2] - 2026-03-05
### Hinzugefügt
- **Adaptive UI-Skalierung:** Einführung einer dynamischen Icon-Berechnung (`dynamicIconSize`). Die Wassertropfen im Overlay passen ihre Größe nun automatisch an das Verhältnis von Tagesziel und Glasgröße an, um eine perfekte Darstellung ohne Scrollen zu gewährleisten.
- **Intelligentes Grid-Layout:** Das Overlay-System berechnet nun die exakte Anzahl der benötigten Symbole basierend auf dem Quotienten aus Zielvolumen und Glasvolumen.
- Dynamisches Live-Rendering für UML-Diagramme in der Online-Dokumentation (Mermaid.js Integration).
- Neues Sequenzdiagramm für den Overlay-Manager (/PF10/).
- Zustandsdiagramm für die App-Logik (/PF20/).

### Geändert
- **macOS Design-Refinement:** Komplette Überarbeitung der `SettingsView` unter Verwendung von `LabeledContent`. Dies sorgt für ein exaktes Alignment der Labels und Steuerelemente gemäß den Apple Human Interface Guidelines.
- **Erweiterte Symbolik:** Dynamischer Wechsel des Header-Icons auf einen Erfolgs-Status (`checkmark.circle.fill`), sobald das Tagesziel erreicht wurde.
- **Optimierte Button-Interaktion:** Buttons in den Einstellungen nutzen nun `.buttonStyle(.borderless)` für ein dezenteres, systemkonformes Erscheinungsbild.

### Behoben
- **Layout-Clutter:** Fix eines Fehlers, bei dem die UI-Elemente im Overlay bei hohen Tageszielen oder sehr kleinen Glasgrößen über den Bildschirmrand hinausragten.
- Fehlerhafte Darstellung der Architektur-Grafiken auf GitHub Pages.
- Reduzierung von Repository-Müll durch optimierte `.gitignore`.

## [1.4.1]
### Hinzugefügt
- **Individuelle Glasgrößen:** Einstellbare Glasgröße (100ml - 1000ml).
- **Dynamische Zielsetzung:** Individuelles Tagesziel-Limit (dynamische RuleMark im Chart).
- **Intelligente Berechnung:** Automatische Berechnung der benötigten Glasanzahl in den Einstellungen.

### Geändert
- Overlay-Logik von statischen 200ml auf dynamische `@AppStorage`-Werte umgestellt.
- CSV-Export nutzt nun die konfigurierten Volumen-Werte.
- Refactoring der `SettingsView` für bessere Übersicht.

## [1.4.0]
### Hinzugefügt
- **Unbegrenztes Tracking (Bonus-Gläser):** Einführung eines permanent sichtbaren, grünen Plus-Buttons (`plus.circle.fill`), um Wasser über das ursprüngliche Tagesziel hinaus zu loggen.
- **Echtzeit-Statistiken:** Die Chart-Ansicht und der CSV-Export berechnen nun zur Laufzeit den heutigen Live-Wert in Kombination mit der Historie.
- **Statischer QR-Code:** Die rechenintensive, dynamische QR-Code-Generierung wurde durch ein performantes, statisches Bild-Asset ersetzt.
- **Wake-from-Sleep Erkennung:** Der `AppDelegate` nutzt nun `NSWorkspace.didWakeNotification` für einen zuverlässigen Tages-Reset nach dem Ruhezustand.

### Behoben
- **Kritischer Datums-Bug (Reset-Logik):** Der Tagesvergleich nutzt nun ein festes ISO-8601 Format, was Fehler bei unterschiedlichen Systemsprachen behebt.
- **CSV-Formatierung:** Liter-Werte im CSV-Export verwenden jetzt das Komma `,` für bessere Kompatibilität mit Excel/Numbers im europäischen Raum.

## [1.3.0]
### Hinzugefügt
- **Vollständiger Dokumentations-Abgleich:** Pflichtenheft exakt an Lastenheft angepasst.
- **Traceability Matrix:** Test-Szenarien und Abnahmekriterien im Pflichtenheft integriert.
- **Erweiterter CSV-Export:** Integration des `NSSavePanel` für einen nutzerfreundlichen Speicher-Dialog.

### Geändert
- **Datenhygiene:** Automatische Löschung von Historien-Einträgen, die älter als 14 Tage sind.

## [1.2.0]
### Geändert
- **Zentralisierung der Logik:** Auslagerung der Fenster-Steuerung in den `OverlayManager`.
- **Multi-Monitor-Support:** Optimierung der Bildschirmschleife für lückenlose Abdeckung aller aktiven Displays.
- **Haptisches Feedback:** Integration des `NSHapticFeedbackManager` bei Interaktion mit Wassertropfen.

## [1.1.0]
### Hinzugefügt
- **Wartungskonzept:** Dokumentation zur Fehlerprotokollierung und zum Monitor-Management.
- **Projekt-Roadmap:** Planung für Apple Watch Integration und iCloud Sync.

## [1.0.0]
### Hinzugefügt
- **Basis-Funktionalität:** Menüleisten-App zur Erinnerung an die Wasseraufnahme.
- **Overlay-Sperre:** Zeitgesteuerte Vollbild-Verdunkelung (5-120 Min. Intervall).
- **Interaktiver Tracker:** Visuelle Erfassung via Wassertropfen-Icons.
- **Basis-Statistik:** Balkendiagramm via Swift Charts.

[← Zurück zur Übersicht](../README.md)
