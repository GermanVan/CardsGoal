import UIKit

class GameManager {
    static let shared = GameManager()
    var selectedTheme: ColorTheme = ColorTheme.themes[0]
    var goal: Task?
    var stages: [Stage] = []
    var currentStageIndex: Int = 0
    var score: Int = 0

    var currentStage: Stage? {
        guard currentStageIndex < stages.count else { return nil }
        return stages[currentStageIndex]
    }

    func completeTask(_ taskId: UUID) -> Int {
        guard let stage = currentStage, !stage.isCompleted else { return 0 }
        guard let taskIndex = stage.tasks.firstIndex(where: { $0.id == taskId }) else { return 0 }
        if !stage.tasks[taskIndex].isCompleted {
             guard let stageIndex = stages.firstIndex(where: { $0.id == stage.id }) else { return 0 }
             stages[stageIndex].tasks[taskIndex].isCompleted = true
             score += TaskLevel.small.pointsValue
             return TaskLevel.small.pointsValue
        }
        return 0
    }

    func uncompleteTask(_ taskId: UUID) -> Int {
        guard let stage = currentStage, !stage.isCompleted else { return 0 }
        guard let taskIndex = stage.tasks.firstIndex(where: { $0.id == taskId }) else { return 0 }
        if stage.tasks[taskIndex].isCompleted {
             guard let stageIndex = stages.firstIndex(where: { $0.id == stage.id }) else { return 0 }
             stages[stageIndex].tasks[taskIndex].isCompleted = false
             let pointsToSubtract = TaskLevel.small.pointsValue
             score -= pointsToSubtract
             if score < 0 { score = 0 }
             return pointsToSubtract
        }
        return 0
    }

    func updateTaskPosition(taskId: UUID, position: CGPoint) {
        guard let stageIndex = stages.firstIndex(where: { stage in
            stage.tasks.contains(where: { $0.id == taskId })
        }) else { return }
        guard let taskIndex = stages[stageIndex].tasks.firstIndex(where: { $0.id == taskId }) else { return }
        stages[stageIndex].tasks[taskIndex].position = position
    }

    func areAllSmallTasksCompleted() -> Bool {
        guard let stage = currentStage else { return false }
        let smallTasks = stage.tasks.filter { $0.level == .small }
        return !smallTasks.isEmpty && smallTasks.allSatisfy { $0.isCompleted }
    }

    func canAffordMediumTaskCompletion() -> Bool {
        guard let stage = currentStage else { return false }
        return score >= stage.requiredPointsForCompletion
    }

    func areAllPreviousStepsCompleted() -> Bool {
        guard currentStageIndex > 0 else { return true }
        return stages[0..<currentStageIndex].allSatisfy { $0.isCompleted }
    }


    func completeMediumTask() {
        guard currentStageIndex < stages.count else { return }
        guard let currentStageRef = currentStage,
              let mediumTask = currentStageRef.mediumTask ?? currentStageRef.tasks.first(where: {$0.level == .global}),
              let taskIndex = currentStageRef.tasks.firstIndex(where: { $0.id == mediumTask.id }),
              let stageIndex = stages.firstIndex(where: { $0.id == currentStageRef.id })
        else { return }

        stages[stageIndex].tasks[taskIndex].isCompleted = true
        stages[stageIndex].isCompleted = true
    }

    func reset() {
        goal = nil
        stages = []
        currentStageIndex = 0
        score = 0
    }
}

