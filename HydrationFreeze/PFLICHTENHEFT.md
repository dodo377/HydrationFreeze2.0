# Pflichtenheft: HydrationFreeze

**Projekt:** HydrationFreeze (Technische Spezifikation)  
**Version:** 1.4 (Abgeglichen mit Quellcode & Lastenheft v1.4)  
**Status:** Aktiv / Finalisiert für Release v1.4.1

## 1. Technische Architektur
- **Frameworks:** - `SwiftUI`: Gesamte Benutzeroberfläche und Datenbindung.
    - `AppKit`: Fenster-Management (`NSPanel`) für die System-Sperre.
    - `Swift Charts`: Visualisierung der Trink-Historie.
- **Datenhaltung:** `@AppStorage` (UserDefaults) zur Persistenz von Konfigurationsdaten und JSON-Kodierung für das Langzeit-Log (`[HydrationLog]`).
- **Einstiegspunkt:** `MenuBarExtra` sorgt für einen ressourcensparenden Betrieb in der macOS Statusleiste.

## 2. Detaillierte Systemfunktionen (PF)

### 2.1 [ /PF10/ ] Dynamischer Overlay-Mechanismus
- **Klasse:** `OverlayManager`.
- **Umsetzung:** Erzeugung von `NSPanel`-Instanzen mit `styleMask: .borderless` auf dem Level `.screenSaver`.
- **Multi-Monitor-Support:** Automatisierte Iteration über `NSScreen.screens`.
- **Berechnungslogik:** Die `OverlayView` berechnet das angezeigte Volumen dynamisch:  
  $$V_{Liter} = \frac{n_{Gläser} \times V_{Glasgröße}}{1000}$$

### 2.2 [ /PF20/ ] Adaptive Benutzeroberfläche & Interaktion
- **Tracking:** Dynamische Generierung der Trink-Buttons mittels `ForEach(0..<max(8, glassesDrunk), id: \.self)`. Dies verhindert Layout-Fehler bei hohen Trinkmengen.
- **Interaktions-Validierung:** Buttons sind sequenziell gesperrt. Nur das aktuelle Glas (`index == glassesDrunk`) ist aktiv.
- **Visual Effects:** Einsatz von `.symbolEffect(.pulse)` zur Nutzerführung und `NSHapticFeedbackManager` zur Bestätigung.

### 2.3 [ /PF30/ ] Statistik-Engine (Swift Charts)
- **Dynamische Ziellinie:** Implementierung einer `RuleMark` auf der Y-Achse, die an die Variable `dailyGoal` (in Litern) gebunden ist.
- **Status-Indikatoren:** - Blaues Gradient-Design bei Unterschreitung des Ziels.
    - Grünes Gradient-Design bei Erreichung oder Überschreitung des Ziels.
- **Archivierung:** Die Funktion `getHistory()` aggregiert die Tageswerte und stellt sicher, dass Änderungen der Glasgröße rückwirkend für den aktuellen Tag korrekt berechnet werden.


### 2.4 [ /PF40/ ] Konfigurations-Management
- **Nutzerschnittstelle:** `SettingsView` mit Stepper-Elementen für:
    - `selectedGlassSize`: 100ml - 1000ml (50er Schritte).
    - `dailyGoal`: 1000ml - 5000ml (100er Schritte).
- **Persistenz:** Unmittelbare Speicherung aller Änderungen via `@AppStorage` zur synchronen Aktualisierung von Hintergrundprozessen und Overlays.

### 2.5 [ /PF50/ ] Daten-Export & Synchronisation
- **CSV-Schnittstelle:** Nutzung von `NSSavePanel`. Export-Format: `Datum;Liter` (Dezimal-Komma-Konvertierung für EU-Excel-Kompatibilität).
- **Mobile-Sync:** Integration des statischen QR-Code Assets zur Kopplung mit dem iOS-System.

## 3. Test-Szenarien & Abnahme

| Referenz | Testfall | Erwartetes Ergebnis | Status |
| :--- | :--- | :--- | :--- |
| **PF10 / LF10** | Änderung Glasgröße auf 500ml | Overlay zeigt pro Glas 0,5L Schritte an. | ✅ |
| **PF30 / LF20** | Tagesziel auf 3,0L erhöhen | Rote Ziellinie im Chart wandert auf 3.0. | ✅ |
| **PF20 / LF30** | Trinkmenge > 10 Gläser | Overlay erweitert die Button-Reihe korrekt. | ✅ |
| **PF40 / LF70** | CSV-Export | Valide Datei mit korrekt berechneten Litern. | ✅ |

## 4. Wartung & Roadmap
- **v1.5.0:** Integration von Push-Notifications bei verpassten Intervallen.
- **v1.6.0:** Optionale Anbindung an die Apple Health API (macOS).
