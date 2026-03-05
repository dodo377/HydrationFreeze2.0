[← Zurück zur Übersicht](../README.md)

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

### TC-10: Grenzwertanalyse (Eingabevalidierung)

| ID | TC-10 |
| :--- | :--- |
| **Testmethode** | Grenzwertanalyse (Boundary Value Analysis) |
| **Testziel** | Verhindern von ungültigen Zuständen durch Extremwerte. |
| **Testschritte** | 1. Glasgröße auf Minimum (100ml) setzen. <br> 2. Tagesziel auf Maximum (5000ml) setzen. |
| **Erwartetes Ergebnis** | Das System muss 50 Icons generieren. Die App darf nicht abstürzen und die Berechnung muss korrekt bleiben ($V_{total} = 5.0L$). |
| **Status** | ✅ Bestanden |

### TC-11: Entscheidungstabellentest (Overlay-Priorität)

| ID | TC-11 |
| :--- | :--- |
| **Testmethode** | Entscheidungstabelle (Decision Table) |
| **Bedingungen** | 1. Timer abgelaufen? (JA) <br> 2. Ziel bereits erreicht? (JA) <br> 3. Sperre aktiv? (JA) |
| **Erwartetes Ergebnis** | Auch wenn das Tagesziel erreicht ist, muss die Sperre ausgelöst werden (Gesundheitsaspekt: Pause/Bewegung), aber die Anzeige muss den Erfolgsstatus (Grün/Haken) direkt zeigen. |
| **Status** | ✅ Bestanden |

### TC-12: Error Guessing (Robustheit)

| ID | TC-12 |
| :--- | :--- |
| **Testmethode** | Fehlerraten (Error Guessing) |
| **Testziel** | Verhalten bei unvorhergesehenen Systemereignissen. |
| **Testschritte** | Während das Overlay aktiv ist, wird ein Monitor physisch getrennt. |
| **Erwartetes Ergebnis** | Der `OverlayManager` muss das Fenster-Layout sofort neu berechnen und die Sperre auf dem verbleibenden Monitor lückenlos aufrechterhalten. |
| **Status** | ✅ Bestanden |

---

## 3. Testprotokoll (Test Log)

| Test-Lauf | Testfall-ID | Datum | Tester | Ergebnis | Bemerkung |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **v1.4.1-Base** | TC-01, TC-02 | 03.03.2026 | [Doreen Obendorf] | **Pass** | Timer und Multi-Monitor-Abdeckung (Basis-Regression). |
| **v1.4.1-Data** | TC-05, TC-06 | 03.03.2026 | [Doreen Obendorf] | **Pass** | Mitternachts-Reset und CSV-Export verifiziert. |
| **v1.4.2-Logic** | TC-03, TC-04 | 05.03.2026 | [Doreen Obendorf] | **Pass** | Volumen-Logik bei 500ml und Chart-RuleMark-Verschiebung. |
| **v1.4.2-UI** | **TC-07** | 05.03.2026 | [Doreen Obendorf] | **Pass** | **Adaptive Skalierung:** Icons skalieren bei 30 Tropfen auf 20pt. |
| **v1.4.2-UX** | **TC-08, TC-09** | 05.03.2026 | [Doreen Obendorf] | **Pass** | Statuswechsel (Haken) und LabeledContent-Alignment (macOS HIG). |
| **v1.4.2-Boundary**| **TC-10** | 05.03.2026 | [Doreen Obendorf] | **Pass** | **Grenzwert:** 100ml Glas bei 5L Ziel (50 Icons) wird korrekt berechnet. |
| **v1.4.2-Logic+** | **TC-11** | 05.03.2026 | [Doreen Obendorf] | **Pass** | **Entscheidungstabelle:** Sperre triggert auch bei erfülltem Tagesziel. |
| **v1.4.2-Robust** | **TC-12** | 05.03.2026 | [Doreen Obendorf] | **Pass** | **Error Guessing:** Overlay reagiert stabil auf Monitor-Trennung. |
| **v1.4.2-Git** | - | 05.03.2026 | [Doreen Obendorf] | **Pass** | **Deployment:** Git-Divergenz durch Merge-Sync gelöst. |

### Zusammenfassung der Testergebnisse
Alle Testfälle wurden erfolgreich abgeschlossen. Besonders hervorzuheben ist die Stabilität der **adaptiven UI-Skalierung (TC-07)**, die auch bei extremen Nutzerkonfigurationen (kleine Glasgrößen bei hohem Tagesziel) ein sauberes Layout ohne Clipping gewährleistet. Das Projekt ist in der Version 1.4.2 technisch und visuell abnahmebereit.

---

## 4. Fehlerbericht (Defect Report)

| ID | Beschreibung | Methode | Status | Lösung |
| :--- | :--- | :--- | :--- | :--- |
| **DEF-01** | **Layout-Clipping:** Icons ragten bei 25+ Tropfen über den Rand. | TC-07 | ✅ Behoben | Dynamische `dynamicIconSize` und ScrollView-Container. |
| **DEF-02** | **UI-Inkonsistenz:** Schlechtes Alignment in den Einstellungen. | TC-09 | ✅ Behoben | Umstellung auf native `LabeledContent` Container. |
| **DEF-03** | **Git-Divergenz:** Remote/Lokal-Historie asynchron. | - | ✅ Behoben | Manueller Merge-Sync und Force-Alignment der Tags. |
| **DEF-04** | **Division-by-Zero:** Potenzielle Gefahr bei Glasgröße 0ml. | TC-10 | ✅ Behoben | Validierung im Stepper verhindert Werte unter 100ml. |
| **DEF-05** | **Zustands-Fehler:** Sperre blieb bei Zielerreichung aus. | TC-11 | ✅ Behoben | Logik-Update: Sperre triggert unabhängig vom Fortschritt. |

---
*Status: Keine kritischen Defekte (Showstopper) verbleibend.*

[← Zurück zur Übersicht](../README.md)
