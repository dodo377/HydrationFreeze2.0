# Testdokumentation: HydrationFreeze

**Version:** 1.4 | **Referenz:** Lastenheft v1.4, Pflichtenheft v1.4  
**Standard:** Angelehnt an ISTQB (IEEE 829)  
**Status:** Validiert für Release v1.4.1

---

## 1. Testplan (Test Plan)

### 1.1 Einführung & Gültigkeitsbereich
Dieses Dokument beschreibt die Teststrategie für Version 1.4. Der Fokus liegt auf der korrekten mathematischen Skalierung der UI und Datenberechnung nach Einführung der variablen Glasgröße und des individuellen Tagesziels.

### 1.2 Testobjekte
- **HydrationFreeze App** (macOS) - Version 1.4
- **Lokale UserDefaults** Datenspeicherstruktur (`selectedGlassSize`, `dailyGoal`, `historyJSON`)

### 1.3 Zu testende Merkmale (Features to be tested)
- **Dynamische Skalierung:** Korrekte Berechnung der Liter-Werte bei Glasgrößen von 100ml bis 1000ml.
- **Ziel-Logik:** Triggerung der "Erfolg-Nachricht" basierend auf dem Erreichen des `dailyGoal` Volumens.
- **Chart-Integrität:** Korrekte Positionierung der `RuleMark` (Ziellinie) bei dynamischer Zieländerung.
- **Daten-Export:** Konsistenz der exportierten Liter-Werte mit den konfigurierten Volumina.

---

## 2. Testfallspezifikation (Test Case Specification)

### TC-01: Timer und Overlay-Aktivierung
| ID | TC-01 |
| :--- | :--- |
| **Testziel** | Überprüfung der Intervallsteuerung. |
| **Vorbedingung** | Intervall in den Einstellungen ist auf 5 Minuten gesetzt. |
| **Erwartetes Ergebnis** | Das Overlay verdunkelt nach exakt 5 Min. alle Bildschirme. |
| **Status** | ✅ Bestanden |

### TC-02: Multi-Monitor Abdeckung
| ID | TC-02 |
| :--- | :--- |
| **Testziel** | Sicherstellung der Sperrung aller angeschlossenen Displays. |
| **Vorbedingung** | Mindestens ein externer Monitor ist angeschlossen. |
| **Erwartetes Ergebnis** | Das Overlay erscheint synchron auf allen erkanntem `NSScreen`-Instanzen. |
| **Status** | ✅ Bestanden |

### TC-03: Dynamische Volumen-Logik (Grenzwertanalyse)
| ID | TC-03 |
| :--- | :--- |
| **Testziel** | Validierung der Volumenberechnung bei nicht-standardmäßigen Glasgrößen. |
| **Vorbedingung** | Einstellungen: `selectedGlassSize` = 500ml, `dailyGoal` = 2000ml. |
| **Testschritte** | 1. Overlay öffnen. <br> 2. Vier Tropfen nacheinander anklicken. |
| **Erwartetes Ergebnis** | Unter dem Tropfen steht "0,5L". Nach genau 4 Klicks erscheint "Tagesziel erreicht! 🎉". |
| **Status** | ✅ Bestanden |

### TC-04: Chart-Visualisierung (Dynamische RuleMark)
| ID | TC-04 |
| :--- | :--- |
| **Testziel** | Überprüfung der Korrelation zwischen User-Input und Grafik. |
| **Vorbedingung** | Statistik-Tab ist sichtbar. |
| **Testschritte** | 1. `dailyGoal` von 2,0L auf 3,5L erhöhen. <br> 2. Chart prüfen. |
| **Erwartetes Ergebnis** | Die rote `RuleMark` verschiebt sich auf Y=3.5. Die Annotation zeigt korrekt "Ziel: 3.5L". |
| **Status** | ✅ Bestanden |



### TC-05: Mitternachts-Reset & Archivierung
| ID | TC-05 |
| :--- | :--- |
| **Testziel** | Korrekte Archivierung des Tagesvolumens bei Datumswechsel. |
| **Vorbedingung** | `selectedGlassSize` = 300ml, `glassesDrunk` = 3 (0,9L). |
| **Testschritte** | 1. Systemdatum manuell auf +1 Tag stellen. <br> 2. App-Aktion auslösen. |
| **Erwartetes Ergebnis** | Statistik zeigt für den Vortag einen Balken bei exakt 0,9L. Heutiger Zähler ist 0. |
| **Status** | ✅ Bestanden |

### TC-06: CSV-Export (Lokalisierung & Präzision)
| ID | TC-06 |
| :--- | :--- |
| **Testziel** | Exportierte Werte reflektieren die dynamische Glasgröße und EU-Formatierung. |
| **Vorbedingung** | `selectedGlassSize` = 250ml, `glassesDrunk` = 1. |
| **Erwartetes Ergebnis** | CSV enthält Zeile mit Wert `0,25` (Dezimal-Komma-Trennung). |
| **Status** | ✅ Bestanden |

---

## 3. Testprotokoll (Test Log)

| Test-Lauf | Datum | Tester | Umgebung | Ergebnis | Bemerkung |
| :--- | :--- | :--- | :--- | :--- | :--- |
| v1.4-Final | 05.03.2026 | [Dein Name] | macOS 14.x (Apple Silicon) | Pass | Alle dynamischen Skalierungen erfolgreich. |

---

## 4. Fehlerbericht (Defect Report)
*Aktuell keine kritischen Fehler offen.*
