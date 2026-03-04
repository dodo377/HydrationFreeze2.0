# Lastenheft: HydrationFreeze

**Projekt:** macOS Hydration Tracker mit Overlay-Sperre  
**Version:** 1.3

## 1. Zielsetzung
Förderung der Gesundheit am Arbeitsplatz durch eine App, die den Nutzer in festen Intervallen zur Wasseraufnahme zwingt. Die App unterbricht den Workflow visuell und bietet eine Dokumentationsmöglichkeit.

## 2. Funktionale Anforderungen
- **Zeitgesteuerter Reminder:** Automatisches Auslösen einer Vollbild-Sperre in konfigurierbaren Intervallen.
- **Vollbild-Sperre:** Überlagerung aller angeschlossenen Monitore (Sperrdauer einstellbar).
- **Interaktives Tracking:** 10 klickbare Gläser (je 0,2L) zur Erfassung der Menge direkt im Overlay.
- **Motivationssystem:** 10 individuelle Sprüche, die sich je nach Gläseranzahl aktualisieren.
- **Statistik:** Grafische Aufbereitung der letzten 14 Tage (Balkendiagramm) inkl. 2L-Ziellinie.
- **Daten-Export:** Sicherung der Historie als CSV-Datei über einen Datei-Dialog.
- **Mobile-Sync:** Bereitstellung eines QR-Codes zur Kopplung mit dem iOS-Kurzbefehl "WasserLog".

## 3. Nicht-funktionale Anforderungen
- **Agent-App:** Ausführung als Menüleisten-App ohne permanentes Dock-Icon.
- **Persistenz:** Sicherung des Fortschritts über System-Ruhezustände hinweg.
- **Datenschutz:** Vollständig lokale Datenhaltung in den System-UserDefaults.
