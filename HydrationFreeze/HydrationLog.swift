import Foundation

struct HydrationLog: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let amount: Double
}
