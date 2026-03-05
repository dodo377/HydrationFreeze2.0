# Testdokumentation: HydrationFreeze

**Version:** 1.4.2 | **Referenz:** Lastenheft v1.4.2, Pflichtenheft v1.4.2  
**Standard:** Angelehnt an ISTQB (IEEE 829)  
**Status:** Validiert für Release v1.4.2

---

## 1. Testplan (Test Plan)

### 1.1 Einführung & Gültigkeitsbereich
Dieses Dokument beschreibt die Teststrategie für Version 1.4.2. Der Fokus liegt auf der **visuellen Integrität** und der **adaptiven UI-Skalierung** bei variablen Glas- und Zielgrößen sowie der Einhaltung der macOS Design-Richtlinien in den Einstellungen.

### 1.2 Testobjekte
- **HydrationFreeze App** (macOS) - Version 1.4.2
- **UI-Komponenten:** Adaptive `OverlayView`, Refactored `SettingsView`.

### 1.3 Zu testende Merkmale (Features to be tested)
- **Adaptive Icon-Skalierung:** Korrekte Größenanpassung der Tropfen-Icons bei hoher Anzahl (>10 bis >20 Gläser).
- **Responsive Layout:** Verhinderung von Layout-Clutter und Overlap im Vollbild-Overlay.
- **Header-Status-Logik:** Korrekter Wechsel der Icons/Farben bei Erreichung des Tagesziels.
- **Design-Konformität:** Korrektes Alignment der UI-Elemente in den Einstellungen (v1.4.2 Refactoring).

---

## 2. Testfallspezifikation (Test Case Specification)

### TC-01 bis TC-06 (Übernommen aus v1.4.1)
*Alle funktionalen Tests bezüglich Timer, Multi-Monitor, CSV-Export und Reset-Logik wurden erfolgreich re-validiert (Regression Test).*

### TC-07: Adaptive Icon-Größe (Scaling Test)
| ID | TC-07 |
| :--- | :--- |
| **Testziel** | Validierung der dynamischen Verkleinerung der Icons bei kleinen Glasgrößen. |
| **Vorbedingung** | Einstellungen: `dailyGoal` = 3000ml, `selectedGlassSize` = 100ml (Ergibt 30 Icons). |
| **Erwartetes Ergebnis** | Icons werden automatisch auf die kleinste Stufe (20pt) reduziert. Alle 30 Icons sind ohne Scrollen sichtbar und überlappen sich nicht. |
| **Status** | ✅ Bestanden |

### TC-08: UI-Statuswechsel (Goal Reach)
| ID | TC-08 |
| :--- | :--- |
| **Testziel** | Visuelle Bestätigung der Zielerreichung im Overlay. |
| **Testschritte** | Gläser tracken, bis `currentTotalML >= dailyGoal`. |
| **Erwartetes Ergebnis** | 1. Header-Icon wechselt von `drop.circle.fill` (blau) zu `checkmark.circle.fill` (grün). <br> 2. Motivationstext zeigt "Wahnsinn! Du bist über dem Ziel! 🏆". |
| **Status** | ✅ Bestanden |

### TC-09: Alignment-Check (Settings View)
| ID | TC-09 |
| :--- | :--- |
| **Testziel** | Überprüfung der macOS-Konformität des neuen Layouts. |
| **Erwartetes Ergebnis** | Labels (z.B. "Tagesziel") sind exakt linksbündig ausgerichtet. Die dazugehörigen Stepper/Picker sind rechtsbündig ausgerichtet (`LabeledContent`-Standard). |
| **Status** | ✅ Bestanden |

---

## 3. Testprotokoll (Test Log)

| Test-Lauf | Datum | Tester | Umgebung | Ergebnis | Bemerkung |
| :--- | :--- | :--- | :--- | :--- | :--- |
| v1.4.1-Base | 03.03.2026 | [Name] | macOS 14.x | Pass | Basis-Funktionen stabil. |
| **v1.4.2-UI** | **05.03.2026** | **[Name]** | **macOS 14.x** | **Pass** | **Adaptive Skalierung erfolgreich validiert.** |

---

## 4. Fehlerbericht (Defect Report)
* **Behoben (v1.4.2):** Icons ragten bei 25+ Tropfen über den Fensterrand hinaus. -> *Gefixed durch dynamische `dynamicIconSize` und `ScrollView`-Container.*
