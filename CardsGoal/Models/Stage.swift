import Foundation

struct Stage {
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
    
    var totalSmallTasksPoints: Int {
        return smallTasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
    }
    
    var canCompleteMediumTask: Bool {
        return totalSmallTasksPoints >= (mediumTask?.points ?? 0)
    }
}

