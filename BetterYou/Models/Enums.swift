import Foundation

enum WorkoutType: String, Codable, CaseIterable, Identifiable {
    case strength
    case cardio
    case bodyweight
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .strength: "Strength"
        case .cardio: "Cardio"
        case .bodyweight: "Bodyweight"
        case .custom: "Custom"
        }
    }

    var icon: String {
        switch self {
        case .strength: "figure.strengthtraining.traditional"
        case .cardio: "figure.run"
        case .bodyweight: "figure.flexibility"
        case .custom: "star.fill"
        }
    }
}

enum QuestCadence: String, Codable {
    case daily
    case weekly
}

enum TargetMetric: String, Codable {
    case workoutsCount
    case totalDurationSec
    case totalVolumeKg
    case distanceKm
}

enum StoreCategory: String, Codable, CaseIterable {
    case avatar
    case badge
    case freeze

    var displayName: String {
        switch self {
        case .avatar: "Avatars"
        case .badge: "Badges & Titles"
        case .freeze: "Power-ups"
        }
    }
}

struct SetEntry: Codable, Hashable, Identifiable {
    var id = UUID()
    var reps: Int
    var weightKg: Double?
    var durationSec: Int?
}
