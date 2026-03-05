# 💧 HydrationFreeze (macOS)

**HydrationFreeze** ist ein intelligenter Trink-Reminder für macOS, der Gesundheit zur Priorität macht. Die App unterbricht den Workflow in festen Intervallen durch ein Vollbild-Overlay und motiviert dazu, das tägliche Ziel von 2 Litern nicht nur zu erreichen, sondern zu übertreffen.

---

## ✨ Features

- **Smart Blocking Overlay**: Legt sich über alle Monitore, um eine kurze Trinkpause zu erzwingen.
- **Unbegrenztes Tracking**: Ein 10-Gläser-System für das Basis-Ziel (2L) plus ein dynamischer Plus-Button für zusätzliche Hydrierung.
- **Echtzeit-Statistik**: Ein Dashboard mit **Swift Charts**, das archivierte Daten und den aktuellen Tagesfortschritt kombiniert.
- **Robuster Tages-Reset**: Erkennt Datumswechsel zuverlässig beim App-Start und beim Aufwachen des Macs (Wake-from-Sleep).
- **Mobile-Sync**: Ein statischer QR-Code (via qr.io) erlaubt das schnelle Loggen in Apple Health via iPhone.
- **Tahoe Ready**: Nutzt moderne APIs für Menüleisten-Extras und haptisches Feedback.

---

## 🚀 Installation & Setup

### 1. Xcode Konfiguration
Damit die App ordnungsgemäß funktioniert, müssen folgende Einstellungen in Xcode vorgenommen werden:
- **App Sandbox**: Muss deaktiviert sein (`Signing & Capabilities`), damit die App Fenster über das System-Level (`.screenSaver`) legen darf.
- **LSUIElement**: Setze `Application is agent (UIElement)` in der `Info.plist` auf `YES`, um das Dock-Icon auszublenden (Menüleisten-App).

### 2. iPhone Kurzbefehl (Shortcut)
Für die Synchronisation mit Apple Health:
1. Öffne die **Kurzbefehle**-App auf deinem iPhone.
2. Erstelle einen neuen Kurzbefehl mit dem Namen **`WasserLog`**.
3. Füge die Aktion **"Wasser protokollieren"** hinzu (Wert: 200 ml).
4. Nun kannst du den QR-Code im Mac-Overlay einfach scannen.



---

## 🛠 Bedienung

| Bereich | Funktion |
| :--- | :--- |
| **Menüleiste** | Startet manuelle Testsperren und bietet schnellen Zugriff auf Einstellungen. |
| **Sperrbildschirm** | Erscheint automatisch. Klicke auf die Tropfen oder den Plus-Button zum Loggen. |
| **Statistik** | Visualisiert die letzten 14 Tage. Balken wachsen über die 2L-Marke hinaus. |
| **Export** | Speichert die Historie als `;`-separierte CSV-Datei. |

---

## 📂 Projektstruktur

- `HydrationApp.swift`: Steuerzentrale der App, Timer-Logik und Menüleisten-Steuerung.
- `OverlayManager.swift`: Verwaltet die `NSPanel` Instanzen und das visuelle Design des Sperrbildschirms.
- `SettingsView.swift`: Beinhaltet die Konfiguration, die Swift Charts Statistik und den QR-Generator.
- `HydrationLog.swift`: Das Datenmodell für die persistente Speicherung via `UserDefaults`.

---

## 🛡 Systemanforderungen

- **OS**: macOS 14.0+ (Sonoma / Optimiert für macOS Tahoe 26.2)
- **Hardware**: Getestet auf Apple Silicon (M1/M2/M3/M4) und Intel Macs.

---

## 📄 Lizenz

Dieses Projekt ist unter der **MIT-Lizenz** lizenziert. Das bedeutet, du darfst den Code frei verwenden, verändern und weitergeben, solange der ursprüngliche Urheberrechtshinweis erhalten bleibt. 

Details findest du in der englischsprachigen [LICENSE](LICENSE) Datei.
