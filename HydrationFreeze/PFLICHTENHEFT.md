[← Zurück zur Übersicht](../README.md)

# Pflichtenheft: HydrationFreeze

**Projekt:** HydrationFreeze (Technische Spezifikation)  
**Version:** 1.4.2 (Abgeglichen mit Quellcode & Lastenheft v1.4.2)  
**Status:** Aktiv / Finalisiert für Release v1.4.2

---

## 1. Technische Architektur
- **Frameworks:** - `SwiftUI`: Gesamte Benutzeroberfläche und Datenbindung.
    - `AppKit`: Fenster-Management (`NSPanel`) für die System-Sperre.
    - `Swift Charts`: Visualisierung der Trink-Historie.
- **Datenhaltung:** `@AppStorage` (UserDefaults) zur Persistenz von Konfigurationsdaten und JSON-Kodierung für das Langzeit-Log (`[HydrationLog]`).
- **Einstiegspunkt:** `MenuBarExtra` sorgt für einen ressourcensparenden Betrieb in der macOS Statusleiste.

---

## 2. Detaillierte Systemfunktionen (PF)

### 2.1 [ /PF10/ ] Dynamischer Overlay-Mechanismus
- **Klasse:** `OverlayManager`.
- **Umsetzung:** Erzeugung von `NSPanel`-Instanzen mit `styleMask: .borderless` auf dem Level `.screenSaver`.
- **Multi-Monitor-Support:** Automatisierte Iteration über `NSScreen.screens`.
- **Adaptive Skalierungslogik (Neu in v1.4.2):** Die `OverlayView` berechnet die Icon-Größe $S_{Icon}$ dynamisch in Abhängigkeit der Gesamtzahl der benötigten Gläser ($n_{Total}$), um die Bildschirmbreite optimal zu nutzen:
  $$S_{Icon} = \begin{cases} 45 & \text{wenn } n \leq 8 \\ 35 & \text{wenn } 8 < n \leq 12 \\ 25 & \text{wenn } 12 < n \leq 20 \\ 20 & \text{wenn } n > 20 \end{cases}$$

### 2.2 [ /PF20/ ] Adaptive Benutzeroberfläche & Interaktion
- **Dynamisches Grid:** Nutzung von `max(glassesNeededForGoal, glassesDrunk)` für die Generierung der Button-Reihe. Dies stellt sicher, dass das Ziel visualisiert wird, auch wenn noch nichts getrunken wurde.
- **Responsives Design:** Einbettung der `glassesRow` in eine horizontale `ScrollView` und dynamisches Spacing, um Überlappungen bei extremen Konfigurationen (z. B. 100ml Gläser bei 5L Ziel) zu verhindern.
- **Erfolgs-Feedback:** Bedingte Formatierung des Headers; Wechsel zu `.green` und `checkmark.circle.fill` bei Erreichung von `isGoalReached`.

### 2.3 [ /PF30/ ] Statistik-Engine (Swift Charts)
- **Dynamische Ziellinie:** Implementierung einer `RuleMark` auf der Y-Achse, die an die Variable `dailyGoal` (in Litern) gebunden ist.
- **Status-Indikatoren:** - Blaues Gradient-Design bei Unterschreitung des Ziels.
    - Grünes Gradient-Design bei Erreichung oder Überschreitung des Ziels.
- **Archivierung:** Die Funktion `getHistory()` aggregiert die Tageswerte und stellt sicher, dass Änderungen der Glasgröße rückwirkend für den aktuellen Tag korrekt berechnet werden.

### 2.4 [ /PF40/ ] Konfigurations-Management (Refactoring v1.4.2)
- **Nutzerschnittstelle:** Umstellung der `SettingsView` auf Apple Human Interface Guidelines (HIG) konformes Layout:
    - Einsatz von `Form`-Clustern zur Strukturierung.
    - Verwendung von `LabeledContent` zur sauberen Trennung von Deskriptor und Steuerelement.
    - Kompakte Darstellung durch `.controlSize(.regular)` und `.buttonStyle(.borderless)`.

### 2.5 [ /PF50/ ] Daten-Export & Synchronisation
- **CSV-Schnittstelle:** Nutzung von `NSSavePanel`. Export-Format: `Datum;Liter` (Dezimal-Komma-Konvertierung für EU-Excel-Kompatibilität).
- **Mobile-Sync:** Integration des statischen QR-Code Assets zur Kopplung mit dem iOS-System.

---

## 3. Test-Szenarien & Abnahme

| Referenz | Testfall | Erwartetes Ergebnis | Status |
| :--- | :--- | :--- | :--- |
| **PF10 / LF30** | Ziel: 4L, Glas: 200ml (20 Icons) | Icons werden automatisch auf 25pt verkleinert; Overlay bleibt übersichtlich. | ✅ |
| **PF40 / LF35** | Öffnen der Einstellungen | Alle Beschriftungen sind linksbündig ausgerichtet; Stepper rechtsbündig. | ✅ |
| **PF20 / LF60** | Zielerreichung im Overlay | Header-Icon wechselt zu grünem Haken; Text gratuliert zum Erfolg. | ✅ |
| **PF10 / LF10** | Änderung Glasgröße auf 500ml | Overlay zeigt pro Glas 0,5L Schritte an. | ✅ |
| **PF30 / LF20** | Tagesziel auf 3,0L erhöhen | Ziellinie im Chart wandert auf 3.0. | ✅ |
| **PF40 / LF70** | CSV-Export | Valide Datei mit korrekt berechneten Litern. | ✅ |

---

## 4. Wartung & Roadmap
- **v1.5.0:** Integration von Push-Notifications bei verpassten Intervallen.
- **v1.6.0:** Optionale Anbindung an die Apple Health API (macOS).

[← Zurück zur Übersicht](../README.md)
