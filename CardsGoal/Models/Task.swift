import UIKit

enum TaskLevel: Int {
    case small = 0
    case medium = 1
    case global = 2
    
    var pointsValue: Int {
        switch self {
        case .small: return 10
        case .medium: return 80
        case .global: return 300
        }
    }
}

struct Task {
    var id = UUID()
    var title: String
    var isCompleted = false
    var level: TaskLevel
    var position: CGPoint? // Позиция карточки на экране
    
    var points: Int {
        return level.pointsValue
    }
}
