import Foundation
import SwiftData

@Model
final class WeightLog {
    var id: UUID
    var date: Date
    var weightKg: Double

    init(date: Date = Date(), weightKg: Double) {
        self.id = UUID()
        self.date = date
        self.weightKg = weightKg
    }
}
