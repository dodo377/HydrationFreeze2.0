# 💧 HydrationFreeze (macOS)

> **Ein intelligenter Trink-Reminder, der dich daran erinnert etwas zu trinken.**

[![Release](https://img.shields.io/github/v/release/dodo377/HydrationFreeze2.0?color=blue)](https://github.com/dodo377/HydrationFreeze2.0/releases)
[![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-lightgrey)](https://apple.com/macos)
[![Docs](https://img.shields.io/badge/Doku-GitHub%20Pages-green)](https://dodo377.github.io/HydrationFreeze2.0/)

---

## 📖 Projektdokumentation
Besuche die **[interaktive Dokumentations-Seite](https://dodo377.github.io/HydrationFreeze2.0/)** für eine saubere Leseansicht:

* [**Lastenheft**](./HydrationFreeze/LASTENHEFT.md) | [**Pflichtenheft**](./HydrationFreeze/PFLICHTENHEFT.md) | [**Testdokumentation**](./HydrationFreeze/TESTDOKUMENTATION.md) | [**Changelog**](./HydrationFreeze/CHANGELOG.md) | [**Handbuch**](./HydrationFreeze/HANDBUCH.md)

---

## 🛡️ Qualitätssicherung (V-Modell & ISTQB)
Dieses Projekt zeichnet sich durch einen hohen Qualitätsstandard aus. Die Entwicklung folgt dem V-Modell, um eine lückenlose Rückverfolgbarkeit von den Anforderungen bis zu den verifizierten Testfällen zu gewährleisten.
- **Test-Suite:** Über 14 definierte Testfälle (TC-01 bis TC-14).
- **Methodik:** Einsatz von Grenzwertanalysen und Entscheidungstabellentests zur Absicherung kritischer Logikpfade.
- **Standard:** Dokumentation angelehnt an den **ISTQB-Standard** (basierend auf IEEE 829).

## 🧠 Funktionsweise (Logic Flow)
Die App folgt einer strikten Zustandslogik, um sicherzustellen, dass du dein Tagesziel erreichst:

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> OverlaySperre: Timer abgelaufen & Ziel offen
    OverlaySperre --> Idle: Wasser geloggt
    Idle --> ZielErreicht: Tagesziel erfüllt
```


---

## ✨ Features (v1.4.3 Update)

- **Präzisions-Tracking (Neu in v1.4.3):** Optimierte Volumenberechnung mit zwei Nachkommastellen. Perfekt für 250ml-Gläser (0.25L, 0.50L, 0.75L) ohne Rundungsfehler.
- **Nahtlose Interaktion:** Das Overlay schließt sich nun sofort nach der Interaktion automatisch (**DEF-06 Fix**).
- **Robuster Mitternachts-Reset:** Dank `.NSCalendarDayChanged` Observer erkennt die App den Tageswechsel nun auch im aktiven Betrieb exakt um 00:00 Uhr.
- **Adaptive UI & Smart Scaling:** Das Overlay berechnet die Icon-Größe dynamisch. Egal ob 4 große Gläser oder 20 kleine Tropfen – das Interface skaliert verlustfrei.
- **macOS Native Design:** Einstellungsansicht nach Apple Human Interface Guidelines (SwiftUI `LabeledContent`).
- **Adaptive Statistik:** Dashboard mit Swift Charts, inklusive dynamischer Ziellinie (`RuleMark`).
- **Mobile-Sync:** Statischer QR-Code zum schnellen Loggen via iPhone Kurzbefehl direkt in Apple Health.

---

## 🚀 Installation & Setup

### 1. Xcode Konfiguration
Damit die App ordnungsgemäß funktioniert, müssen folgende Einstellungen in Xcode vorgenommen werden:
- **App Sandbox**: Muss deaktiviert sein (`Signing & Capabilities`), damit die App Fenster über das System-Level (`.screenSaver`) legen darf.
- **LSUIElement**: Setze `Application is agent (UIElement)` in der `Info.plist` auf `YES`, um das Dock-Icon auszublenden.

### 2. iPhone Kurzbefehl (Shortcut)
Für die Synchronisation mit Apple Health:
1. Öffne die **Kurzbefehle**-App auf deinem iPhone.
2. Erstelle einen neuen Kurzbefehl mit dem Namen **`WasserLog`**.
3. Füge die Aktion **"Wasser protokollieren"** hinzu.
   - *Tipp: Nutze als Wert die gleiche Menge, die du in HydrationFreeze als Glasgröße eingestellt hast.*
4. Scanne den QR-Code im Mac-Overlay zum schnellen Ausführen.

---

## 🛠 Bedienung

| Bereich | Funktion |
| :--- | :--- |
| **Optionen** | **Neu:** Natives macOS-Layout für Intervalle, Sperrdauer, Glasgröße (ml) und Tagesziel (L). |
| **Sperrbildschirm** | **Adaptive Darstellung:** Klicke auf die Tropfen zum Loggen – die Icons skalieren automatisch bei hohen Zielen. |
| **Statistik** | Visualisiert die letzten 14 Tage. Balken wechseln die Farbe zu Grün, sobald dein individuelles Ziel erreicht ist. |
| **Export** | Speichert die Historie als lokalisierte `;`-separierte CSV-Datei (Excel/Numbers kompatibel). |

---

## 📂 Projektstruktur

- `HydrationFreezeApp.swift`: Steuerzentrale der App, Timer-Logik und Menüleisten-Steuerung.
- `OverlayManager.swift`: Fenster-Management (`NSPanel`) und Multi-Monitor-Logik.
- `OverlayView.swift`: **Herzstück der v1.4.2** – Berechnet das adaptive Icon-Scaling und die Ziel-Visualisierung.
- `SettingsView.swift`: Konfiguration im nativem Design, Swift Charts Statistik und QR-Sync.

---

## 🛡 Systemanforderungen

- **OS**: macOS 14.0+ (Optimiert für macOS 15+ / Apple Silicon & Intel)
- **Status**: Validiert für Release v1.4.3 (2026)

---

## 📄 Lizenz

Dieses Projekt ist unter der **MIT-Lizenz** lizenziert. Details findest du in der [LICENSE.md](LICENSE.md).
<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
<script>
  mermaid.initialize({ startOnLoad: true });
  // Dieser kleine Zusatz erzwingt das Rendering für GitHub Pages
  window.onload = function() {
    mermaid.init(undefined, document.querySelectorAll('.language-mermaid'));
  };
</script>
