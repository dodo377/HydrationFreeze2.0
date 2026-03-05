[← Zurück zur Übersicht](../README.md)

# 📘 Benutzerhandbuch: HydrationFreeze

**Version:** 1.4.2  
**Plattform:** macOS 14.0+ (Sonoma & Tahoe 26 ready)  
**Projekt:** HydrationFreeze – Dein intelligenter Trink-Begleiter.

---

## 1. Einleitung
Willkommen bei **HydrationFreeze**! Diese App wurde entwickelt, um dich nicht nur ans Trinken zu erinnern, sondern dich sanft (aber bestimmt) dazu zu zwingen, eine kurze Pause für deine Hydrierung einzulegen. 

> **Die Philosophie:** Ein einfacher Reminder wird oft weggeklickt. Eine Bildschirmsperre wird wahrgenommen.

---

## 2. Erste Schritte

### 2.1 Installation
1. Lade das neueste Release `HydrationFreeze_v1.4.2.zip` herunter.
2. Entpacke die Datei und ziehe die App in deinen **Programme-Ordner**.
3. Starte die App. Da sie direkt in der **Menüleiste** (oben rechts) läuft, öffnet sich kein herkömmliches Fenster.

### 2.2 Systemberechtigungen
Damit HydrationFreeze den Bildschirm sperren kann, nutzt es native macOS-Mechanismen (`NSPanel`). In manchen Fällen fragt macOS nach der Berechtigung für "Bedienungshilfen" oder "Bildschirmaufnahme" (für die Monitor-Erkennung) – bitte bestätige diese, um den vollen Funktionsumfang zu nutzen.

---

## 3. Die Funktionen im Überblick

### 3.1 Die Menüleiste (MenuBar)
Das Tropfen-Icon in deiner Menüleiste ist deine Schaltzentrale. Ein Klick darauf öffnet:
* **Aktueller Status:** Wie viel hast du heute bereits getrunken?
* **Statistiken:** Ein Mini-Chart deiner letzten 14 Tage.
* **Einstellungen:** Konfiguriere dein Ziel und deine Intervalle.
* **Pause-Modus:** Deaktiviere die Sperre vorübergehend (z. B. für Präsentationen).

### 3.2 Das Overlay (Die "Sperre")
Sobald dein eingestellter Timer abläuft, erscheint das Overlay auf **allen angeschlossenen Monitoren**.



* **Interaktion:** Du kannst die Sperre nur aufheben, indem du auf ein **Glas-Icon** klickst (was bedeutet: "Ich habe gerade ein Glas getrunken").
* **Dynamik:** Je mehr Gläser du pro Tag trinken musst, desto kleiner werden die Icons automatisch skaliert (v1.4.2 Adaptive Scaling), damit sie immer perfekt auf deinen Schirm passen.

### 3.3 Statistiken & Fortschritt
Im Statistik-Fenster siehst du deine Trink-Historie.
* **Blaue Balken:** Ziel noch nicht erreicht.
* **Grüne Balken:** Tagesziel erfolgreich absolviert!
* **Ziellinie:** Die gestrichelte Linie zeigt dir dein persönliches Tagesziel (z. B. 2,0 Liter).

---

## 4. Konfiguration & Anpassung

Über das Zahnrad-Icon oder den Menüpunkt "Einstellungen" kannst du die App individualisieren:

| Einstellung | Beschreibung | Empfehlung |
| :--- | :--- | :--- |
| **Tagesziel** | Gesamtmenge in ml (z. B. 2000ml). | 2000ml - 3000ml |
| **Glasgröße** | Menge pro Log-Einheit (z. B. 250ml). | 200ml (entspricht 10 Gläsern) |
| **Erinnerungs-Intervall** | Zeit zwischen den Sperren (in Minuten). | 45 - 60 Minuten |
| **Start bei Anmeldung** | App öffnet sich automatisch beim Hochfahren. | Ein (für maximale Disziplin) |

---

## 5. Profi-Features

### 5.1 QR-Code Sync (Apple Health)
Du möchtest deine Daten auch auf dem iPhone haben?
1. Öffne die Einstellungen in HydrationFreeze.
2. Scanne den **QR-Code** mit deinem iPhone.
3. Dies löst einen vorkonfigurierten iOS-Shortcut aus, der die getrunkene Menge direkt in **Apple Health** einträgt.

### 5.2 CSV-Datenexport
Für Daten-Liebhaber bietet HydrationFreeze einen CSV-Export an. Du findest diesen in der Statistik-Ansicht. Die Datei ist für Microsoft Excel (EU-Format mit Semikolon) optimiert.

---

## 6. FAQ & Problemlösung

**Frage: Die Sperre kommt während eines Meetings, was tun?** *Antwort: Nutze vorher den "Pause-Modus" in der Menüleiste. Die Sperre wird dann für 1, 2 oder 4 Stunden ausgesetzt.*

**Frage: Warum werden die Icons plötzlich kleiner?** *Antwort: Das ist ein Feature der v1.4.2! Wenn du ein sehr hohes Ziel oder sehr kleine Gläser wählst, verkleinert die App die Icons, damit sie nicht dein gesamtes Sichtfeld überlagern.*

**Frage: Wann werden die Daten zurückgesetzt?** *Antwort: Automatisch um 00:00 Uhr Ortszeit.*

---
*Support: Falls du Fehler findest, erstelle bitte ein Issue im [GitHub Repository](https://github.com/dodo377/HydrationFreeze2.0).*

[← Zurück zur Übersicht](../README.md)
