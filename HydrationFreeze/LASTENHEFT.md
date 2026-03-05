# Lastenheft: HydrationFreeze

**Projekt:** macOS Hydration Tracker mit Overlay-Sperre  
**Version:** 1.4  
**Status:** Finalisiert für Release v1.4.1

---

## 1. Zielsetzung
Förderung der Gesundheit am Arbeitsplatz durch eine App, die den Nutzer in festen Intervallen zur Wasseraufnahme zwingt. Die App unterbricht den Workflow visuell und bietet eine Dokumentationsmöglichkeit, die sich individuell an die Trinkgewohnheiten des Nutzers anpasst.

---

## 2. Funktionale Anforderungen (LF)

* **[ /LF10/ ] Individualisierung der Glasgröße** Die Software muss es dem Nutzer ermöglichen, die bevorzugte Glasgröße (in ml) in einem Bereich von 100ml bis 1000ml festzulegen.

* **[ /LF20/ ] Dynamische Zielsetzung** Der Nutzer muss ein tägliches Hydrations-Ziel (in Litern) definieren können (Bereich 1,0L bis 5,0L), welches als Referenz für alle Erfolgsmeldungen dient.

* **[ /LF30/ ] Adaptive Benutzeroberfläche** Alle Statistiken (Balkendiagramm) und das Sperrbildschirm-Overlay müssen sich automatisch an die gewählte Glasgröße und das Tagesziel anpassen.

* **[ /LF40/ ] Zeitgesteuerter Reminder** Automatisches Auslösen einer Vollbild-Sperre in konfigurierbaren Intervallen (5 bis 120 Minuten).

* **[ /LF50/ ] Vollbild-Sperre (Overlay)** Überlagerung aller angeschlossenen Monitore mit einer Sperrdauer von 5 bis 60 Sekunden. Ein Umgehen der Sperre während der Laufzeit ist zu verhindern.

* **[ /LF60/ ] Interaktives Tracking** Bereitstellung klickbarer Symbole im Overlay zur Erfassung der getrunkenen Wassermenge in Echtzeit.

* **[ /LF70/ ] Daten-Export** Sicherung der Trink-Historie als CSV-Datei über einen System-Datei-Dialog, wobei die Volumenberechnung auf den konfigurierten Werten basieren muss.

* **[ /LF80/ ] Mobile-Sync per QR-Code** Anzeige eines statischen QR-Codes zur Kopplung mit externen Automatisierungstools (z. B. iOS-Kurzbefehle).

---

## 3. Nicht-funktionale Anforderungen (NF)

* **[ /NF10/ ] Menubar-Only Betrieb** Die App muss als Agent-App im Hintergrund laufen und darf nur über ein Icon in der macOS Menüleiste erreichbar sein.

* **[ /NF20/ ] Daten-Persistenz** Sicherung aller Nutzereinstellungen und des täglichen Fortschritts über System-Neustarts und Ruhezustände hinweg mittels lokaler `UserDefaults`.

* **[ /NF30/ ] Datenschutz & Offline-First** Es darf keine Übertragung von Trinkdaten an externe Server stattfinden. Die App muss vollständig ohne Internetverbindung funktionsfähig sein.
