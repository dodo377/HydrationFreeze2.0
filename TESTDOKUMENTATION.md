# Testdokumentation: HydrationFreeze
**Version:** 1.0 | **Referenz:** Lastenheft v1.4, Pflichtenheft v1.4  
**Standard:** Angelehnt an ISTQB (IEEE 829)

---

## 1. Testplan (Test Plan)

### 1.1 Einführung & Gültigkeitsbereich
Dieses Dokument beschreibt die Teststrategie, Testfälle und Abnahmekriterien für die macOS-Anwendung "HydrationFreeze". Der Fokus liegt auf dem System- und Abnahmetest der Geschäftslogik (Tracking, Reset) und der Benutzeroberfläche (Overlay, Charts).

### 1.2 Testobjekte
- HydrationFreeze App (macOS) - Version 1.4
- Lokale `UserDefaults` Datenspeicherstruktur

### 1.3 Zu testende Merkmale (Features to be tested)
- Timer- und Intervallsteuerung (Fokus: Zuverlässigkeit)
- Overlay-Verhalten (Fokus: Multi-Monitor-Sperre)
- Tracking-Logik (Fokus: Basis-10-Gläser und unbegrenzter Bonus-Zähler)
- Persistenz und Tages-Reset (Fokus: Datumsgrenzen und System-Ruhezustand)
- CSV-Export und Diagramm-Aktualisierung

### 1.4 Nicht zu testende Merkmale (Features not to be tested)
- Native Apple Health App (Third-Party)
- Erreichbarkeit der qr.io Webseite (Statisches Bild wird vorausgesetzt)
- Exakte Millisekunden-Genauigkeit des Apple `Timer`-Frameworks

### 1.5 Testumgebung & Testwerkzeuge
- **Hardware:** Mac (Apple Silicon / Intel) mit mindestens einem externen Monitor.
- **Betriebssystem:** macOS 14.0 (Sonoma) oder neuer.
- **Werkzeuge:** Terminal (zur Manipulation der UserDefaults für Zeitreisen-Tests).

### 1.6 Abbruchkriterien (Suspension Criteria)
Die Testdurchführung wird gestoppt, wenn die App beim Start crasht (Fatal Error) oder das Overlay sich nicht mehr durch den Nutzer schließen lässt (Blocker).

---

## 2. Testfallspezifikation (Test Case Specification)

Die Testfälle basieren auf den Black-Box-Testentwurfsverfahren (Grenzwertanalyse und Äquivalenzklassenbildung).

### TC-01: Timer und Overlay-Aktivierung
| ID | TC-01 |
| :--- | :--- |
| **Testziel** | Überprüfung, ob das Overlay nach Ablauf des eingestellten Intervalls erscheint. |
| **Vorbedingung** | App läuft. Intervall in den Einstellungen ist auf 5 Minuten gesetzt. |
| **Testschritte** | 1. 5 Minuten ohne Interaktion warten.<br>2. Prüfen, ob das Overlay auf dem Hauptbildschirm erscheint. |
| **Erwartetes Ergebnis** | Das Overlay verdunkelt den Bildschirm. Die verbleibende Zeit läuft ab. |
| **Status** | [ ] Offen |

### TC-02: Multi-Monitor Abdeckung
| ID | TC-02 |
| :--- | :--- |
| **Testziel** | Sicherstellung, dass alle Bildschirme gesperrt werden. |
| **Vorbedingung** | Ein zweiter Monitor ist an den Mac angeschlossen. App läuft. |
| **Testschritte** | 1. "Jetzt trinken (Test)" über die Menüleiste manuell auslösen.<br>2. Zustand beider Monitore prüfen. |
| **Erwartetes Ergebnis** | Beide Monitore zeigen das schwarze (94% Alpha) Overlay. Klicks auf den zweiten Monitor werden vom Hintergrund absorbiert. |
| **Status** | [ ] Offen |

### TC-03: Tracking-Logik (Grenzwertanalyse 2,0L Limit)
| ID | TC-03 |
| :--- | :--- |
| **Testziel** | Validierung des Wechsels von den 10 Basis-Gläsern zum dynamischen Plus-Button. |
| **Vorbedingung** | Overlay ist aktiv, `glassesDrunk` = 0. |
| **Testschritte** | 1. 9 Tropfen nacheinander anklicken.<br>2. Den 10. Tropfen anklicken.<br>3. Prüfen der UI-Veränderung.<br>4. Den neuen Plus-Button anklicken (11. Glas). |
| **Erwartetes Ergebnis** | Bei 10 Klicks: Nachricht wechselt auf Zielerreichung. Das 11. Element (Grünes Plus-Icon) erscheint dauerhaft und der Zähler erhöht sich auf 2.2L. |
| **Status** | [ ] Offen |

### TC-04: Mitternachts-Reset (Zustandsbezogener Test)
| ID | TC-04 |
| :--- | :--- |
| **Testziel** | Der `lastUpdateDay` Check funktioniert beim Datumswechsel. |
| **Vorbedingung** | App ist beendet. Zählerstand in UserDefaults > 0. |
| **Testschritte** | 1. Terminal öffnen: `defaults write [Bundle ID] lastUpdateDay "2020-01-01"`<br>2. App starten.<br>3. Zählerstand im UI (Settings) prüfen. |
| **Erwartetes Ergebnis** | Der Zähler von heute ist 0. In der Statistik (Chart) ist ein neuer Balken für den "gestrigen" (manipulierten) Tag sichtbar. |
| **Status** | [ ] Offen |

### TC-05: Wake-from-Sleep Resynchronisation
| ID | TC-05 |
| :--- | :--- |
| **Testziel** | Das `didWakeNotification` Event löst den Check aus. |
| **Vorbedingung** | App läuft im Hintergrund. |
| **Testschritte** | 1. Systemeinstellungen > Datum um einen Tag in die Zukunft stellen.<br>2. Mac in den Ruhezustand (Sleep) versetzen.<br>3. Mac aufwecken. |
| **Erwartetes Ergebnis** | Die App bemerkt den Tagessprung sofort nach dem Aufwachen. Tageszähler wird auf 0 gesetzt. |
| **Status** | [ ] Offen |

### TC-06: CSV-Export und Datenintegrität
| ID | TC-06 |
| :--- | :--- |
| **Testziel** | Der Export erzeugt eine valide, lokalisierte CSV. |
| **Vorbedingung** | Historie enthält mindestens 2 Einträge. Tageszähler hat einen Wert > 0 (z. B. 0.4L). |
| **Testschritte** | 1. Einstellungen > "CSV Export" klicken.<br>2. Datei auf dem Schreibtisch speichern.<br>3. Datei mit einem Texteditor öffnen. |
| **Erwartetes Ergebnis** | Header lautet `Datum;Liter`. Werte sind durch Semikolon getrennt, Liter-Zahlen nutzen Kommas (z. B. `05.03.2024;2,4`). Der heutige Live-Wert ist im Export enthalten. |
| **Status** | [ ] Offen |

---

## 3. Testprotokoll (Test Log)
*Dieses Protokoll wird während der Testdurchführung ausgefüllt.*

| Test-Lauf | Datum | Tester | Umgebung | Ergebnis | Bemerkung |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Run 1 | DD.MM.YYYY | [Dein Name] | macOS 14.x | [ ] Pass / [ ] Fail | Initiale Abnahme |

## 4. Fehlerbericht (Defect Report / Incident Report)
*Vorlage zur Dokumentation fehlgeschlagener Tests.*

- **Fehler-ID:** BUG-001
- **Betroffener Testfall:** [z.B. TC-05]
- **Schweregrad:** [Blocker / Critical / Major / Minor]
- **Beschreibung:** [Was genau ist passiert?]
- **Reproduzierbarkeit:** [Immer / Sporadisch]
