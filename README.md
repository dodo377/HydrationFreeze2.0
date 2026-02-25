# 💧 Hydration Hero (macOS)

**Hydration Hero** ist ein minimalistischer, aber effektiver Trink-Reminder für macOS. Die App hilft dir, deine tägliche Wasserzufuhr während der Arbeit im Blick zu behalten, indem sie in festen Intervallen eine kurze "Zwangspause" durch ein Vollbild-Overlay einfordert.

---

## ✨ Features

- **Smart Blocking Overlay**: Schaltet sich über alle aktiven Bildschirme, um eine kurze Trinkpause zu erzwingen.
- **10-Gläser-Tracker**: Interaktives Tracking von 10 Gläsern (je 0,2L) pro Tag für das 2-Liter-Ziel.
- **Visualisierte Statistik**: Integriertes Dashboard mit **Swift Charts**, das deinen Fortschritt der letzten 14 Tage farblich auswertet (Grün bei Zielerreichung).
- **Cross-Account Sync**: Ein dynamisch generierter **QR-Code** erlaubt es, via iPhone-Shortcuts Wasser in Apple Health zu loggen – selbst wenn Mac und iPhone unterschiedliche Apple-IDs nutzen.
- **Daten-Export**: Export deiner Historie als `.csv` Datei direkt aus den Einstellungen.
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
| **Menüleiste** | Startet manuelle Testsperren und öffnet die Einstellungen. |
| **Sperrbildschirm** | Erscheint automatisch alle X Minuten. Klicke auf die Tropfen, um zu loggen. |
| **Statistik** | Zeigt deine Beständigkeit. Balken werden blau (im Prozess) oder grün (Ziel erreicht). |
| **Export** | Speichert deine gesamte `historyJSON` als lesbare Tabelle. |



---

## 📂 Projektstruktur

- `HydrationApp.swift`: Steuerzentrale der App, Timer-Logik und Menüleisten-Steuerung.
- `OverlayManager.swift`: Verwaltet die `NSPanel` Instanzen und das visuelle Design des Sperrbildschirms.
- `SettingsView.swift`: Beinhaltet die Konfiguration, die Swift Charts Statistik und den QR-Generator.
- `HydrationLog.swift`: Das Datenmodell für die persistente Speicherung via `UserDefaults`.

---

## 🛡 Systemanforderungen

- **OS**: macOS 14.0+ (Optimiert für macOS Tahoe)
- **Hardware**: Getestet auf Apple Silicon (M1/M2/M3/M4) und Intel Macs.

---

## 📝 Lizenz
Dieses Projekt wurde als Lernprojekt erstellt. Nutzung und Modifikation sind ausdrücklich erlaubt.
