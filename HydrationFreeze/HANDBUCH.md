[← Zurück zur Übersicht](../README.md)

# 📘 Benutzerhandbuch: HydrationFreeze

**Version:** 1.4.2  
**Plattform:** macOS 13.0+  
**Projekt:** HydrationFreeze – Konsequentes Trink-Management.

---

## 1. Einleitung
Willkommen bei **HydrationFreeze**! Diese App wurde entwickelt, um dich nicht nur ans Trinken zu erinnern, sondern dich durch eine Bildschirmsperre aktiv dazu zu bewegen, eine kurze Pause für deine Hydrierung einzulegen. 

> **Die Philosophie:** Ein einfacher Reminder wird oft ignoriert. Eine Bildschirmsperre erzwingt die Handlung und schützt deine Gesundheit am Arbeitsplatz.

---

## 2. Erste Schritte

### 2.1 Installation
1. Lade das neueste Release `HydrationFreeze_v1.4.2.zip` herunter.
2. Entpacke die Datei und ziehe die App in deinen **Programme-Ordner**.
3. Starte die App. Das Icon erscheint in der **Menüleiste** (oben rechts).

### 2.2 Systemberechtigungen
Damit HydrationFreeze den Bildschirm systemweit sperren kann, nutzt es das native `NSPanel`. Bitte bestätige eventuelle macOS-Sicherheitsabfragen, damit die App das Overlay korrekt über alle Fenster legen darf.

---

## 3. Die Funktionen im Überblick

### 3.1 Die Menüleiste (MenuBar)
Ein Klick auf das Tropfen-Icon öffnet das Hauptmenü:
* **Aktueller Status:** Zeigt dein Trink-Volumen des heutigen Tages.
* **Statistiken:** Ein Diagramm deiner Erfolge der letzten 14 Tage.
* **Einstellungen:** Hier definierst du dein Ziel und die Glasgröße.
* **Beenden:** Schließt die App und stoppt alle Timer.

### 3.2 Das Overlay (Die Sperre)
Sobald dein eingestellter Timer abläuft, erscheint das Overlay auf **allen angeschlossenen Monitoren**.



* **Interaktion:** Die Sperre lässt sich nur aufheben, indem du auf ein **Glas-Icon** klickst. Dies bestätigt, dass du gerade ein Glas Wasser getrunken hast.
* **Skalierung (v1.4.2):** Die App berechnet die Icon-Größe automatisch. Wenn du viele kleine Gläser trinkst, werden die Icons kleiner dargestellt, um den Bildschirm optimal zu nutzen.

### 3.3 Statistiken (Swift Charts)
In der Statistik-Ansicht wird dein Fortschritt visualisiert:
* **Balken:** Zeigen das Volumen pro Tag.
* **Farben:** Blau bedeutet "in Arbeit", Grün bedeutet "Tagesziel erreicht".
* **Ziellinie:** Die RuleMark im Chart zeigt dir dein eingestelltes Tagesziel.

---

## 4. Konfiguration

| Einstellung | Beschreibung |
| :--- | :--- |
| **Tagesziel** | Die Gesamtmenge Wasser pro Tag (z. B. 2500ml). |
| **Glasgröße** | Die Menge pro Klick im Overlay (z. B. 200ml). |
| **Intervall** | Zeit zwischen den Sperren (Standard: 60 Min). |

---

## 5. Zusatz-Features

### 5.1 QR-Code Sync
In den Einstellungen findest du einen QR-Code. Scanne diesen mit deinem iPhone, um einen Kurzbefehl auszulösen, der dein Trink-Event direkt in **Apple Health** überträgt.

### 5.2 Daten-Export
Über die Statistik-Ansicht kannst du deine Historie als **CSV-Datei** exportieren, um sie beispielsweise in Excel weiterzuverarbeiten.

---

## 6. FAQ

**Frage: Wie werde ich die Sperre los, ohne zu trinken?** *Antwort: HydrationFreeze ist auf Disziplin ausgelegt. Ein Klick auf ein Glas ist der einzige Weg, das Overlay zu schließen. In Notfällen kann die App über `Cmd + Q` beendet werden.*

**Frage: Wann werden die Daten zurückgesetzt?** *Antwort: Automatisch um Mitternacht.*

---
*Support & Feedback: [GitHub Repository](https://github.com/dodo377/HydrationFreeze2.0).*

[← Zurück zur Übersicht](../README.md)
