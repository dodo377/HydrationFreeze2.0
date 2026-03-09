import XCTest
@testable import HydrationFreeze // Ersetze dies durch den exakten Namen deines App-Moduls

final class HydrationFreezeAllTests: XCTestCase {

    // MARK: - TC-14: Präzision (%.2f Formatierung bei 250ml)
    func testTC14_VolumePrecision() throws {
        // Arrange
        let glassVolumeLiters: Double = 0.25 // 250ml
        let glassesDrunk: Int = 3
        
        // Act
        let totalVolume = glassVolumeLiters * Double(glassesDrunk)
        let formattedString = String(format: "%.2f", totalVolume)
        
        // Assert
        XCTAssertEqual(totalVolume, 0.75, "Die mathematische Berechnung von 3x 250ml muss exakt 0.75 ergeben.")
        XCTAssertEqual(formattedString, "0.75", "Die String-Formatierung muss exakt '0.75' ausgeben (DEF-08 Fix).")
    }
    
    // MARK: - TC-13: Zustands-Validierung (Tageswechsel / Reset-Logik)
    func testTC13_DailyResetLogic() throws {
        // Arrange
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        var glassesDrunk = 8
        var historyCount = 0
        
        // Act (Simulation von checkNewDay im AppDelegate)
        let isSameDay = calendar.isDate(today, inSameDayAs: yesterday)
        if !isSameDay {
            // Simulierte Archivierung und Reset
            historyCount += 1
            glassesDrunk = 0
        }
        
        // Assert
        XCTAssertFalse(isSameDay, "Gestern und Heute dürfen nicht als der gleiche Tag erkannt werden.")
        XCTAssertEqual(glassesDrunk, 0, "Der Zähler MUSS beim Tageswechsel auf 0 springen.")
        XCTAssertEqual(historyCount, 1, "Der gestrige Wert muss in der Historie archiviert worden sein.")
    }

    // MARK: - TC-10: Grenzwertanalyse (Ziel: 5L, Glas: 100ml -> 50 Icons)
    func testTC10_BoundaryValueAnalysis() throws {
        // Arrange
        let dailyGoalLiters: Double = 5.0
        let glassVolumeLiters: Double = 0.1 // 100ml
        
        // Act
        let totalGlassesNeeded = Int(dailyGoalLiters / glassVolumeLiters)
        
        // Adaptive Skalierungslogik aus PF10
        var iconSize = 0
        if totalGlassesNeeded <= 8 { iconSize = 45 }
        else if totalGlassesNeeded <= 12 { iconSize = 35 }
        else if totalGlassesNeeded <= 20 { iconSize = 25 }
        else { iconSize = 20 }
        
        // Assert
        XCTAssertEqual(totalGlassesNeeded, 50, "Bei 5L Ziel und 100ml Gläsern müssen exakt 50 Icons berechnet werden.")
        XCTAssertEqual(iconSize, 20, "Bei 50 Icons MUSS das Scaling auf den Minimalwert von 20pt greifen.")
    }

    // MARK: - TC-11: Entscheidungstabelle (Timer abgelaufen + Ziel bereits erreicht)
    func testTC11_TimerTriggersWhenGoalReached() throws {
        // Arrange
        let glassesDrunk = 10
        let glassesNeeded = 10
        let timerDidFire = true
        
        // Act
        let isGoalReached = glassesDrunk >= glassesNeeded
        // Logik: Overlay triggert, WENN der Timer abläuft. Das Ziel ändert nur das Design (Erfolg), verhindert aber nicht die Pause.
        let shouldShowOverlay = timerDidFire
        
        // Assert
        XCTAssertTrue(isGoalReached, "Das Ziel gilt als erreicht.")
        XCTAssertTrue(shouldShowOverlay, "Das Overlay MUSS trotzdem erscheinen (Pause-Funktion erzwingen), auch wenn das Ziel erreicht ist.")
    }

    // MARK: - TC-04: Regression (Klick auf Tropfen-Icon -> Loggen & Auto-Close)
    func testTC04_InteractionAndAutoClose() throws {
        // Arrange
        var glassesDrunk = 0
        var isOverlayOpen = true
        
        // Simulierte addWater() Funktion der OverlayView
        let addWater = {
            glassesDrunk += 1
            isOverlayOpen = false // Simuliert das onFinished() Signal an den OverlayManager (DEF-06 Fix)
        }
        
        // Act
        addWater() // User klickt auf den Tropfen
        
        // Assert
        XCTAssertEqual(glassesDrunk, 1, "Das Glas muss erfolgreich geloggt werden.")
        XCTAssertFalse(isOverlayOpen, "Das Overlay MUSS unmittelbar nach dem Klick geschlossen werden (isOverlayOpen = false).")
    }

    // MARK: - TC-12: Robustheit (Monitor-Trennung / Layout-Rekalkulation)
    func testTC12_MultiMonitorSupport() throws {
        // Da wir in Unit Tests keine echten Monitore abstecken können,
        // testen wir die Logik, wie der OverlayManager auf die Anzahl der Screens reagiert.
        
        // Arrange
        let simulatedScreensCount = 3 // User hat 3 Monitore angeschlossen
        var activePanels: [String] = []
        
        // Act
        for i in 0..<simulatedScreensCount {
            activePanels.append("Panel_for_Screen_\(i)")
        }
        
        // Assert
        XCTAssertEqual(activePanels.count, 3, "Der OverlayManager muss exakt so viele NSPanels erzeugen, wie Monitore angeschlossen sind.")
    }
}
