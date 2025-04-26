import Foundation

struct Stage: Equatable {
    var id = UUID()
    var title: String
    var tasks: [Task]
    var isCompleted = false
    
    var smallTasks: [Task] {
        return tasks.filter { $0.level == .small }
    }
    
    var mediumTask: Task? {
        return tasks.first { $0.level == .medium }
    }
    
    var requiredPointsForCompletion: Int {
        return smallTasks.count * TaskLevel.small.pointsValue
    }
        
    static func == (lhs: Stage, rhs: Stage) -> Bool {
        return lhs.id == rhs.id
    }
}

