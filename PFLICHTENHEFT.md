# Pflichtenheft: HydrationFreeze

**Projekt:** HydrationFreeze (Technische Spezifikation)
**Version:** 1.3 (Abgeglichen mit Quellcode & Lastenheft)

## 1. Technische Architektur
- **Frameworks:** SwiftUI (UI), AppKit (Window-Management), Swift Charts (Statistik).
- **Datenhaltung:** `@AppStorage` (UserDefaults) mit JSON-Kodierung für `HydrationLog`.
- **Einstiegspunkt:** `MenuBarExtra` zur Bereitstellung der App-Funktionen in der Statusleiste.

## 2. Detaillierte Systemfunktionen

### 2.1 Overlay-Mechanismus (Entspricht Lastenheft: Vollbild-Sperre)
- **Klasse:** `OverlayManager`.
- **Umsetzung:** Erzeugung von `NSPanel`-Instanzen mit `styleMask: .borderless`.
- **Level:** `.screenSaver` (priorisiert über allen Fenstern).
- **Multi-Monitor:** Iteration über `NSScreen.screens` zur Abdeckung aller Displays.

### 2.2 Interaktion & Motivation
- **Tracking:** 10 Buttons mit `symbolEffect(.bounce/pulse)`. Jeder Klick inkrementiert `glassesDrunk`.
- **Motivation:** Ein `String-Array` mit 10 Quotes. Der Index wird durch `glassesDrunk` gesteuert.
- **Haptik:** Einsatz von `NSHapticFeedbackManager` bei Button-Interaktion.

### 2.3 Statistik & Daten-Management
- **Reset-Logik:** `checkNewDay()` vergleicht das gespeicherte Datum mit `Date()`. Bei Wechsel wird der Vortag in `historyJSON` archiviert.
- **Historie:** Begrenzung auf 14 Einträge via `history.removeFirst()`.
- **CSV-Export:** Implementierung mittels `NSSavePanel`. Exportiert Header `Datum,Liter` und die entsprechenden Datenzeilen.

### 2.4 Mobile Synchronisation
- **Technik:** Einbindung eines statischen Bild-Assets (`QRCode_Sync`), generiert via **qr.io**.
- **Inhalt:** URL-Scheme `shortcuts://run-shortcut?name=WasserLog` zur Erfassung am iPhone.

## 3. Test-Szenarien & Abnahme

| Anforderung | Testfall | Erwartetes Ergebnis |
| :--- | :--- | :--- |
| Intervall-Reminder | Timer-Ablauf | `showOverlays()` wird getriggert. |
| Vollbild-Sperre | Multi-Monitor | Alle Monitore zeigen das schwarze Overlay (94% Alpha). |
| Mitternachts-Reset | Datumswechsel | `glassesDrunk` wird 0, Eintrag erscheint in Statistik. |
| CSV-Export | Export-Button | Dialog öffnet sich, valide `.csv` wird erstellt. |

## 4. Wartung & Roadmap
- **Monitor-Anpassung:** Überwachung von `didChangeScreenParametersNotification`.
- **Wartung:** Jährlicher Check auf API-Deprecations (Swift Charts/SwiftUI).
