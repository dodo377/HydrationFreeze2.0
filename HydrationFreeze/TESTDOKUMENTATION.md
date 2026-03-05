[← Zurück zur Übersicht](../README.md)

# Testdokumentation: HydrationFreeze

**Version:** 1.4.2 | **Referenz:** Lastenheft v1.4.2, Pflichtenheft v1.4.2  
**Standard:** ISTQB-Standard (basierend auf IEEE 829)  
**Status:** Bedingt freigegeben (Bekannter Fehler: DEF-06)

---

## 1. Testkonzept (Test Plan)

### 1.1 Einführung & Testumfang
Dieses Dokument beschreibt die Testaktivitäten für die Version 1.4.2. Der Schwerpunkt liegt auf der **visuellen Integrität**, der **adaptiven UI-Skalierung** bei variablen Konfigurationen sowie der Konformität mit den macOS Design-Richtlinien (Human Interface Guidelines).

### 1.2 Testobjekte
- **HydrationFreeze App** (macOS) - Version 1.4.2
- **UI-Komponenten:** Adaptive `OverlayView`, überarbeitete `SettingsView` (SwiftUI).

### 1.3 Übergeordnete Testziele
- Nachweis der korrekten dynamischen Skalierung bei hoher Icon-Last (>20 Einheiten).
- Validierung der Barrierefreiheit und Layout-Stabilität im Vollbild-Modus.
- Sicherstellung der Regression der Basisfunktionen (Timer, Persistenz) aus v1.4.1.

---

## 2. Testfallspezifikation (Test Case Specification)

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

### 2.2 Spezifische Tests v1.4.2 (Adaptive UI & Skalierung)

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

---

## 3. Testprotokoll (Test Log)

| Test-Lauf | Referenz-IDs | Datum | Tester | Ergebnis | Bemerkung |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **v1.4.2-REG** | **TC-01 – TC-06** | 05.03.2026 | [D. Obendorf] | **Fail** | Regression TC-04 fehlgeschlagen (DEF-06). |
| **v1.4.2-UI** | **TC-07 – TC-09** | 05.03.2026 | [D. Obendorf] | **Pass** | Adaptive Skalierung & Alignment erfolgreich. |
| **v1.4.2-SPEC** | **TC-10 – TC-12** | 05.03.2026 | [D. Obendorf] | **Pass** | Grenzwerte & Robustheit (Hotplugging) stabil. |

---

## 4. Fehlerbericht (Defect Report)

| ID | Beschreibung | Testfall | Status | Lösung / Workaround |
| :--- | :--- | :--- | :--- | :--- |
| **DEF-01** | Layout-Clipping bei >25 Tropfen. | TC-07 | ✅ Behoben | Dynamische $S_{Icon}$ Logik implementiert. |
| **DEF-02** | Unsauberes Settings-Alignment. | TC-09 | ✅ Behoben | Umstellung auf `LabeledContent`. |
| **DEF-04** | Potenzielle Division durch Null. | TC-10 | ✅ Behoben | Stepper-Validierung verhindert Werte < 100ml. |
| **DEF-05** | Sperre fehlte bei Zielerreichung. | TC-11 | ✅ Behoben | Logik-Update für unabhängige Sperr-Trigger. |
| **DEF-06** | **Klick auf Tropfen-Icon loggt Volumen, beendet aber das Overlay nicht.** | TC-04 | ❌ Offen | **Workaround:** App mit `Command + Q` schließen. oder auf ein Symbol im Dock klicken |

---
*Status: Keine kritischen Showstopper für die Datenintegrität. Interaktions-Bug (DEF-06) für v1.4.3 eingeplant.*

[← Zurück zur Übersicht](../README.md)

