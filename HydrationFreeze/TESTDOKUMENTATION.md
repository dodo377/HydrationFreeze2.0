[← Zurück zur Übersicht](../README.md)

# Testdokumentation: HydrationFreeze

**Version:** 1.4.3 | **Referenz:** Lastenheft v1.4.3, Pflichtenheft v1.4.3  
**Standard:** ISTQB-Standard (basierend auf IEEE 829)  
**Status:** ✅ Freigegeben

---

## 1. Testkonzept (Test Plan)

### 1.1 Einführung & Testumfang
Dieses Dokument beschreibt die Testaktivitäten für die Version 1.4.3. Der Schwerpunkt liegt auf der **visuellen Integrität**, der **adaptiven UI-Skalierung** bei variablen Konfigurationen sowie der Konformität mit den macOS Design-Richtlinien (Human Interface Guidelines).

### 1.2 Testobjekte
- **HydrationFreeze App** (macOS) - Version 1.4.3
- **UI-Komponenten:** Adaptive `OverlayView`, überarbeitete `SettingsView` (SwiftUI).

### 1.3 Übergeordnete Testziele
- Nachweis der korrekten dynamischen Skalierung bei hoher Icon-Last (>20 Einheiten).
- Validierung der Barrierefreiheit und Layout-Stabilität im Vollbild-Modus.
- Sicherstellung der Regression der Basisfunktionen (Timer, Persistenz) aus v1.4.1.

---

## 2. Testfallspezifikation (Test Case Specification)
 
### 🤖 Automatisierte Test-Suite (XCTest)
Um die kritische Geschäftslogik abzusichern, wurden ausgewählte Testfälle in eine automatisierte Unit-Test-Suite (`HydrationFreezeTests`) überführt. 

Folgende Tests werden bei jedem Build (und in der CI/CD-Pipeline) automatisch validiert:
* **TC-04:** Interaktions-Logik & Auto-Close
* **TC-10:** Skalierungs-Mathematik (Grenzwertanalyse)
* **TC-11:** Timer-Priorisierung (Entscheidungstabelle)
* **TC-12:** Multi-Monitor-Layout-Logik
* **TC-13:** Tageswechsel-Validierung (`checkNewDay`)
* **TC-14:** Volumen-Präzision (`%.2f`)

*Die verbleibenden UI- und System-Tests (z. B. CSV-Export, QR-Code Scan) werden weiterhin manuell im Rahmen der Release-Freigabe (Black-Box-Testing) durchgeführt.*

### 2.1 Basistests (Regression v1.4.1)

| ID | Prüfpunkt / Beschreibung | Erwartetes Ergebnis | Status |
| :--- | :--- | :--- | :--- |
| **TC-01** | App-Start / Menüleiste | Icon erscheint im MenuBar; Timer startet im Hintergrund. | ✅ |
| **TC-02** | Intervall-Timer | Nach Ablauf der Zeit wird das Overlay-Panel getriggert. | ✅ |
| **TC-03** | System-Sperre | Overlay liegt auf Level `.screenSaver` über allen Fenstern. | ✅ |
| **TC-04** | Glas-Interaktion | Klick auf Icon erhöht Zähler **und** schließt das Overlay. | ⚠️ **Fail** |
| **TC-05** | Daten-Persistenz | Fortschritt bleibt nach App-Neustart (AppStorage) erhalten. | ✅ |
| **TC-06** | Chart-Stabilität | Swift Charts skalieren artefaktfrei bei Fenster-Resizing. | ✅ |

![V-Modell](DocumentationAssets/v-modell_hydrationfreeze_v1.4.2.png)

### 2.2 Spezifische Tests (Adaptive UI & Skalierung)
 
##### v1.4.2

#### TC-07: Adaptive Icon-Größe (Scaling Test)
- **Beschreibung:** Validierung der dynamischen Verkleinerung der Icons bei kleinen Glasgrößen.
- **Vorbedingung:** Einstellungen: 3000ml Ziel / 100ml Glas (30 Icons).
- **Erwartetes Ergebnis:** Icons werden automatisch auf 20pt reduziert. Alle 30 Icons sind ohne Überlappung sichtbar.
- **Status:** ✅ Bestanden

#### TC-08: UI-Statuswechsel (Goal Reach)
- **Beschreibung:** Visuelle Bestätigung der Zielerreichung im Overlay.
- **Erwartetes Ergebnis:** Header-Icon wechselt zu `checkmark.circle.fill` (grün); Motivationstext aktualisiert sich.
- **Status:** ✅ Bestanden

#### TC-09: Alignment-Check (Settings View)
- **Beschreibung:** Prüfung der macOS-Konformität (HIG) des neuen Layouts.
- **Erwartetes Ergebnis:** Labels sind linksbündig, Stepper/Picker rechtsbündig ausgerichtet (`LabeledContent`).
- **Status:** ✅ Bestanden

#### TC-10: Grenzwertanalyse (Extreme Konfiguration)
- **Methode:** Boundary Value Analysis.
- **Szenario:** 100ml Glas bei 5000ml Tagesziel (50 Icons).
- **Erwartetes Ergebnis:** Stabile Generierung von 50 Icons; keine Abstürze; korrekte Berechnung ($V_{total} = 5.0L$).
- **Status:** ✅ Bestanden

#### TC-11: Entscheidungstabellentest (Logik)
- **Methode:** Decision Table Testing.
- **Szenario:** Timer abgelaufen + Ziel bereits erreicht.
- **Erwartetes Ergebnis:** Sperre löst aus (Pausen-Aspekt); Anzeige zeigt sofort Erfolgs-Status (Grün/Haken).
- **Status:** ✅ Bestanden

#### TC-12: Error Guessing (Robustheit)
- **Szenario:** Physische Monitor-Trennung (Hotplugging) bei aktivem Overlay.
- **Erwartetes Ergebnis:** `OverlayManager` berechnet Layout sofort neu; Sperre bleibt lückenlos erhalten.
- **Status:** ✅ Bestanden

##### v1.4.3
 
#### TC-13: Tageswechsel-Reset (Regession)
- **Erwartetes Ergebnis:** Zähler springt um 00:00 Uhr (oder bei System-Wake) auf 0; Historie wird archiviert.
- **Status:** ✅ Bestanden
 
#### TC-14: Präzision der Volumenanzeige
- **Erwartetes Ergebnis:** Bei 250ml-Schritten müssen exakt zwei Nachkommastellen angezeigt werden (0.25, 0.50, 0.75). Keine Rundungsfehler auf 0.2 oder 0.8.
- **Status:** ✅ Bestanden

---

## 3. Testprotokoll (Test Log)

| Test-Lauf | Referenz-IDs | Datum | Tester | Ergebnis | Bemerkung |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **v1.4.2-REG** | **TC-01 – TC-06** | 05.03.2026 | [D. Obendorf] | **Fail** | Regression TC-04 fehlgeschlagen (DEF-06). |
| **v1.4.2-UI** | **TC-07 – TC-09** | 05.03.2026 | [D. Obendorf] | **Pass** | Adaptive Skalierung & Alignment erfolgreich. |
| **v1.4.2-SPEC** | **TC-10 – TC-12** | 05.03.2026 | [D. Obendorf] | **Pass** | Grenzwerte & Robustheit (Hotplugging) stabil. |
| **v1.4.3-REG** | **TC-13** | 06.03.2026 | [D. Obendorf] | **Pass** | TC-13 erfolgreich verifiziert. |
| **v1.4.3-FINAL** | **TC-04, TC-14** | 06.03.2026 | [D. Obendorf] | **Pass** | Alle kritischen Fehler (Overlay, Rundung) behoben. |

---

## 4. Fehlerbericht (Defect Report)

| ID | Beschreibung | Testfall | Status | Lösung / Workaround |
| :--- | :--- | :--- | :--- | :--- |
| **DEF-01** | Layout-Clipping bei >25 Tropfen. | TC-07 | ✅ Behoben | Dynamische $S_{Icon}$ Logik implementiert. |
| **DEF-02** | Unsauberes Settings-Alignment. | TC-09 | ✅ Behoben | Umstellung auf `LabeledContent`. |
| **DEF-04** | Potenzielle Division durch Null. | TC-10 | ✅ Behoben | Stepper-Validierung verhindert Werte < 100ml. |
| **DEF-05** | Sperre fehlte bei Zielerreichung. | TC-11 | ✅ Behoben | Logik-Update für unabhängige Sperr-Trigger. |
| **DEF-06** | Klick auf Tropfen-Icon loggt Volumen, beendet aber das Overlay nicht. | TC-04 | ✅ Behoben  | **Fix:** `onFinished()` Call in `addWater()` integriert. |
| **DEF-07** | Automatischer Reset bei Tageswechsel triggert nicht. | TC-13 | ✅ Behoben | **Fix:** `NSCalendarDayChanged` Observer & Timer-Heartbeat implementiert. |
| **DEF-08** | Inkorrekte Rundung bei 250ml (0.2 statt 0.25). | TC-14 | ✅ Behoben | **Fix:** String-Formatierung von `%.1f` auf `%.2f` korrigiert. |

---
*Status: ✅ **Vollständig freigegeben.** Alle Testfälle der Version 1.4.3 wurden erfolgreich abgeschlossen. Keine bekannten Defekte.*

[← Zurück zur Übersicht](../README.md)

