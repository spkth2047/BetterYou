import Foundation
import SwiftData

@Model
final class Workout {
    var id: UUID
    var type: WorkoutType
    var name: String
    var date: Date
    var durationSec: Int
    var notes: String
    var setsData: Data?
    var distanceKm: Double?
    var caloriesEst: Int?
    var xpEarned: Int

    init(
        type: WorkoutType,
        name: String,
        date: Date = Date(),
        durationSec: Int = 0,
        notes: String = "",
        sets: [SetEntry] = [],
        distanceKm: Double? = nil,
        caloriesEst: Int? = nil,
        xpEarned: Int = 50
    ) {
        self.id = UUID()
        self.type = type
        self.name = name
        self.date = date
        self.durationSec = durationSec
        self.notes = notes
        self.setsData = try? JSONEncoder().encode(sets)
        self.distanceKm = distanceKm
        self.caloriesEst = caloriesEst
        self.xpEarned = xpEarned
    }

    var sets: [SetEntry] {
        get {
            guard let data = setsData else { return [] }
            return (try? JSONDecoder().decode([SetEntry].self, from: data)) ?? []
        }
        set {
            setsData = try? JSONEncoder().encode(newValue)
        }
    }

    var totalVolume: Double {
        sets.reduce(0) { total, entry in
            total + Double(entry.reps) * (entry.weightKg ?? 0)
        }
    }
}
