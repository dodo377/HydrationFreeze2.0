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

#### TC-01: App-Initialisierung (MenuBar)

| ID | TC-01 |
| :--- | :--- |
| **Testziel** | Validierung des korrekten App-Starts in der macOS Umgebung. |
| **Erwartetes Ergebnis** | Das HydrationFreeze-Icon erscheint in der Statusleiste. Das System-Menü reagiert auf Klick; der Timer startet im Hintergrund. |
| **Status** | ✅ Bestanden (Regression) |

#### TC-02: Intervall-Timer (Basisfunktion)

| ID | TC-02 |
| :--- | :--- |
| **Testziel** | Sicherstellung, dass die Zeitsteuerung den Sperr-Prozess auslöst. |
| **Testschritte** | Timer-Intervall auf 1 Minute setzen (Debug-Mode). |
| **Erwartetes Ergebnis** | Nach Ablauf der Zeit wird der `OverlayManager` getriggert und das Vollbild-Fenster erscheint. |
| **Status** | ✅ Bestanden (Regression) |

#### TC-03: System-Sperre (Overlay Level)

| ID | TC-03 |
| :--- | :--- |
| **Testziel** | Prüfung der Sperr-Priorität (Topmost Window). |
| **Erwartetes Ergebnis** | Das Overlay liegt über allen anderen Applikationen (Level `.screenSaver`). Es ist nicht möglich, Fenster dahinter zu fokussieren. |
| **Status** | ✅ Bestanden (Regression) |

#### TC-04: Glas-Interaktion (Logging)

| ID | TC-04 |
| :--- | :--- |
| **Testziel** | Validierung der Dateneingabe über die Benutzeroberfläche. |
| **Testschritte** | Klick auf ein aktives Glas-Icon im Overlay. |
| **Erwartetes Ergebnis** | 1. `glassesDrunk` wird um +1 erhöht. <br> 2. Die `OverlayView` schließt sich sofort (Sperre aufgehoben). |
| **Status** | ✅ Bestanden (Regression) |

#### TC-05: Daten-Persistenz (UserDefaults)

| ID | TC-05 |
| :--- | :--- |
| **Testziel** | Überprüfung der Datensicherheit nach App-Neustart. |
| **Testschritte** | 3 Gläser loggen, App hart beenden (Force Quit) und neu starten. |
| **Erwartetes Ergebnis** | Der Fortschritt bleibt erhalten; die `@AppStorage`-Variablen laden die korrekten Werte. |
| **Status** | ✅ Bestanden (Regression) |

#### TC-06: UI-Stabilität (Chart-Resizing)

| ID | TC-06 |
| :--- | :--- |
| **Testziel** | Prüfung der `Swift Charts` bei Fenstergrößenänderung. |
| **Erwartetes Ergebnis** | Das Diagramm skaliert ohne Artefakte mit der Fenstergröße mit. Die `RuleMark` bleibt korrekt positioniert. |
| **Status** | ✅ Bestanden (Regression) |

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
| **v1.4.2-Regression-Core** | **TC-01 bis TC-04** | 05.03.2026 | [D. Obendorf] | **Pass** | Basisfunktionen & Sperre stabil. |
| **v1.4.2-Regression-Data** | **TC-05** | 05.03.2026 | [D. Obendorf] | **Pass** | Persistenz & Reset-Logik verifiziert. |
| **v1.4.2-Regression-UI** | **TC-06** | 05.03.2026 | [D. Obendorf] | **Pass** | Chart-Skalierung (Regression) stabil. |
| **v1.4.2-New-Scaling** | **TC-07** | 05.03.2026 | [D. Obendorf] | **Pass** | **Fix bestätigt:** Adaptive Skalierung aktiv. |
| **v1.4.2-New-UX** | **TC-08, TC-09** | 05.03.2026 | [D. Obendorf] | **Pass** | Status-Header & HIG-Alignment ok. |
| **v1.4.2-Boundary** | **TC-10** | 05.03.2026 | [D. Obendorf] | **Pass** | Grenzwert (50 Icons) ohne Fehler. |
| **v1.4.2-Decision** | **TC-11** | 05.03.2026 | [D. Obendorf] | **Pass** | Sperre triggert auch bei 100% Fortschritt. |
| **v1.4.2-Robustness** | **TC-12** | 05.03.2026 | [D. Obendorf] | **Pass** | Monitor-Wechsel stabil abgefangen. |

### Zusammenfassung der Testergebnisse
Alle Testfälle wurden erfolgreich abgeschlossen. Besonders hervorzuheben ist die Stabilität der **adaptiven UI-Skalierung (TC-07)**, die auch bei extremen Nutzerkonfigurationen (kleine Glasgrößen bei hohem Tagesziel) ein sauberes Layout ohne Clipping gewährleistet. Das Projekt ist in der Version 1.4.2 technisch und visuell abnahmebereit.

---

## 4. Fehlerbericht (Defect Report)

| ID | Beschreibung | Testfall | Status | Lösung |
| :--- | :--- | :--- | :--- | :--- |
| **DEF-01** | Layout-Clipping bei >25 Tropfen. | TC-07 | ✅ Behoben | Dynamische $S_{Icon}$ Logik implementiert. |
| **DEF-02** | Unsauberes Settings-Alignment. | TC-09 | ✅ Behoben | Umstellung auf `LabeledContent`. |
| **DEF-03** | Git-Divergenz (Deployment). | - | ✅ Behoben | Force-Alignment der Tags & Historie. |
| **DEF-04** | Potenzielle Division durch Null. | TC-10 | ✅ Behoben | Stepper-Validierung (min. 100ml). |
| **DEF-05** | Sperre fehlte bei Zielerreichung. | TC-11 | ✅ Behoben | Logik-Update für unabhängige Sperren. |

---
*Status: Keine kritischen Defekte (Showstopper) verbleibend.*

[← Zurück zur Übersicht](../README.md)
