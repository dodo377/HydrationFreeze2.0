# 💧 HydrationFreeze (macOS)

**HydrationFreeze** ist ein konfigurierbarer Trink-Reminder für macOS, der Gesundheit zur Priorität macht. Die App unterbricht den Workflow in festen Intervallen durch ein Vollbild-Overlay und zwingt zu einer kurzen Pause, um das individuelle Trinkziel zu erreichen.

---

## ✨ Features (v1.4 Update)

- **Individuelle Glasgröße**: Konfiguriere dein Standard-Gefäß (100ml bis 1000ml) für präzises Tracking.
- **Variables Tagesziel**: Setze dein persönliches Limit (z.B. 2,5L oder 3L) – die App passt alle Statistiken und Erfolgsmeldungen automatisch an.
- **Smart Blocking Overlay**: Legt sich über alle Monitore, um eine kurze Trinkpause zu erzwingen. Die Fortschrittsanzeige berechnet sich live aus deiner Glasgröße.
- **Adaptive Statistik**: Ein Dashboard mit **Swift Charts**, das eine dynamische Ziellinie (`RuleMark`) zeigt, die mit deinem eingestellten Tagesziel mitwandert.
- **Robuster Tages-Reset**: Erkennt Datumswechsel zuverlässig beim App-Start und beim Aufwachen des Macs (Wake-from-Sleep).
- **Mobile-Sync**: Ein statischer QR-Code erlaubt das schnelle Loggen in Apple Health via iPhone.
- **Menubar-Only Design**: Läuft dezent in der Statusleiste ohne das Dock zu füllen.

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
| **Optionen** | Intervalle, Sperrdauer, Glasgröße (ml) und Tagesziel (L) einstellen. |
| **Sperrbildschirm** | Erscheint automatisch. Klicke auf die Tropfen zum Loggen – die Liter-Schritte passen sich deiner Glasgröße an. |
| **Statistik** | Visualisiert die letzten 14 Tage. Balken werden grün, sobald dein individuelles Ziel erreicht ist. |
| **Export** | Speichert die Historie als lokalisierte `;`-separierte CSV-Datei. |

---

## 📂 Projektstruktur

- `HydrationFreezeApp.swift`: Steuerzentrale der App, Timer-Logik und Menüleisten-Steuerung.
- `OverlayManager.swift`: Verwaltet die `NSPanel` Instanzen und das dynamische Design des Sperrbildschirms.
- `SettingsView.swift`: Konfiguration, adaptive Swift Charts Statistik und QR-Sync.
- `HydrationLog.swift`: Datenmodell für die persistente Speicherung via `UserDefaults`.

---

## 🛡 Systemanforderungen

- **OS**: macOS 14.0+ (Optimiert für macOS 16 "Tahoe" / 2026)
- **Hardware**: Getestet auf Apple Silicon (M-Serie) und Intel Macs.

---

## 📄 Lizenz

Dieses Projekt ist unter der **MIT-Lizenz** lizenziert. Details findest du in der [LICENSE.md](LICENSE.md).
