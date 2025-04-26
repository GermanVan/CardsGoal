import UIKit

enum TaskLevel: Int {
    case small = 0
    case medium = 1
    case global = 2
    
    var pointsValue: Int {
        switch self {
        case .small: return 10
        case .medium: return 0
        case .global: return 0
        }
    }
}

struct Task: Equatable {
    var id = UUID()
    var title: String
    var isCompleted = false
    var level: TaskLevel
    var position: CGPoint?
    
    var points: Int {
        return level.pointsValue
    }
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
