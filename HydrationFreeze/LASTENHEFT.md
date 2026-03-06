[← Zurück zur Übersicht](../README.md)

# Lastenheft: HydrationFreeze

**Projekt:** macOS Hydration Tracker mit Overlay-Sperre  
**Version:** 1.4.3 
**Status:** Aktualisiert für Release v1.4.3

---

## 1. Zielsetzung
Förderung der Gesundheit am Arbeitsplatz durch eine App, die den Nutzer in festen Intervallen die Wasseraufnahme erinnert. Die App unterbricht den Workflow visuell und bietet eine Dokumentationsmöglichkeit, die sich individuell an die Trinkgewohnheiten des Nutzers anpasst.

---

## 2. Funktionale Anforderungen (LF) - *Aktualisierungen fett markiert*

* **[ /LF10/ ] Individualisierung der Glasgröße** Die Software muss es dem Nutzer ermöglichen, die bevorzugte Glasgröße (in ml) in einem Bereich von 100ml bis 1000ml festzulegen.

* **[ /LF20/ ] Dynamische Zielsetzung** Der Nutzer muss ein tägliches Hydrations-Ziel (in Litern) definieren können (Bereich 1,0L bis 5,0L), welches als Referenz für alle Erfolgsmeldungen dient.

* **[ /LF30/ ] Adaptive Benutzeroberfläche & Intelligentes Scaling** Das System muss die grafische Darstellung der Trinkfortschritte (Tropfen-Icons) im Overlay-Sperrbildschirm dynamisch berechnen. Die Anzahl der Icons muss exakt dem Quotienten aus Tagesziel und Glasgröße entsprechen. **Die Icon-Größe muss sich automatisch verringern (Scaling), um eine vollständige Anzeige ohne Scroll-Zwang bei hohen Zielen oder kleinen Glasgrößen sicherzustellen.**

* **[ /LF35/ ] Natives macOS Einstellungs-Design** Die Konfigurationsoberfläche (SettingsView) muss den macOS-Designrichtlinien entsprechen. Dies umfasst die **korrekte Ausrichtung (Alignment) von Labels und Steuerungselementen** unter Verwendung nativer Systemkomponenten (`LabeledContent), um eine intuitive Bedienbarkeit zu gewährleisten.

* **[ /LF40/ ] Zeitgesteuerter Reminder** Automatisches Auslösen einer Vollbild-Sperre in konfigurierbaren Intervallen (5 bis 120 Minuten).

* **[ /LF50/ ] Vollbild-Sperre (Overlay)** Überlagerung aller angeschlossenen Monitore mit einer Sperrdauer von 5 bis 60 Sekunden. Ein Umgehen der Sperre während der Laufzeit ist zu verhindern.

* **[ /LF60/ ] Interaktives Progress-Tracking** Bereitstellung klickbarer Symbole im Overlay zur Erfassung der getrunkenen Wassermenge in Echtzeit. Die Symbole müssen ihren Status (gefüllt/leer) und die kumulierte Liter-Anzeige in Echtzeit aktualisieren. **Um den Workflow des Nutzers minimal zu belasten, muss das Logging eines Glases die Overlay-Sperre unmittelbar beenden.**

* **[ /LF70/ ] Daten-Export** Sicherung der Trink-Historie als CSV-Datei über einen System-Datei-Dialog, wobei die Volumenberechnung auf den konfigurierten Werten basieren muss.

* **[ /LF80/ ] Mobile-Sync per QR-Code** Anzeige eines statischen QR-Codes zur Kopplung mit externen Automatisierungstools (z. B. iOS-Kurzbefehle).

* **[ /LF90/ ] Automatischer Tages-Reset** Das System muss sicherstellen, dass der Trink-Zähler zu Beginn eines neuen Kalendertages (00:00 Uhr) oder beim ersten Erwachen des Systems an einem neuen Tag automatisch auf Null gesetzt wird. Vorherige Daten müssen dabei in der lokalen Historie archiviert werden.

---

## 3. Nicht-funktionale Anforderungen (NF)

* **[ /NF10/ ] Menubar-Only Betrieb** Die App muss als Agent-App im Hintergrund laufen und darf nur über ein Icon in der macOS Menüleiste erreichbar sein.

* **[ /NF20/ ] Daten-Persistenz** Sicherung aller Nutzereinstellungen und des täglichen Fortschritts über System-Neustarts und Ruhezustände hinweg mittels lokaler `UserDefaults`.

* **[ /NF30/ ] Datenschutz & Offline-First** Es darf keine Übertragung von Trinkdaten an externe Server stattfinden. Die App muss vollständig ohne Internetverbindung funktionsfähig sein.

* **[ /NF40/ ] Visuelle Ergonomie** Die Benutzeroberfläche muss auf unterschiedlichen Bildschirmauflösungen und Monitor-Konfigurationen lesbar und bedienbar bleiben. Das Overlay darf den Nutzer visuell nicht überfordern (Vermeidung von "Clutter").

[← Zurück zur Übersicht](../README.md)
