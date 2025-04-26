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
        guard let stageIndex = stages.firstIndex(where: { stage in
            stage.tasks.contains(where: { $0.id == taskId })
        }) else { return 0 }
        guard let taskIndex = stages[stageIndex].tasks.firstIndex(where: { $0.id == taskId }) else { return 0 }
        if !stages[stageIndex].tasks[taskIndex].isCompleted {
            stages[stageIndex].tasks[taskIndex].isCompleted = true
            score += stages[stageIndex].tasks[taskIndex].points
            return stages[stageIndex].tasks[taskIndex].points
        }
        return 0
    }

    func uncompleteTask(_ taskId: UUID) -> Int {
        guard let stageIndex = stages.firstIndex(where: { stage in
            stage.tasks.contains(where: { $0.id == taskId })
        }) else { return 0 }
        guard let taskIndex = stages[stageIndex].tasks.firstIndex(where: { $0.id == taskId }) else { return 0 }
        if stages[stageIndex].tasks[taskIndex].isCompleted {
            stages[stageIndex].tasks[taskIndex].isCompleted = false
            score -= stages[stageIndex].tasks[taskIndex].points
            return stages[stageIndex].tasks[taskIndex].points
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

    func completeMediumTask() {
        guard currentStageIndex < stages.count else { return }
        if let mediumTask = stages[currentStageIndex].mediumTask,
           let taskIndex = stages[currentStageIndex].tasks.firstIndex(where: { $0.id == mediumTask.id }) {
            if stages[currentStageIndex].canCompleteMediumTask && !mediumTask.isCompleted {
                stages[currentStageIndex].tasks[taskIndex].isCompleted = true
                stages[currentStageIndex].isCompleted = true
                if currentStageIndex < stages.count - 1 {
                    currentStageIndex += 1
                }
            }
        }
    }

    func reset() {
        goal = nil
        stages = []
        currentStageIndex = 0
        score = 0
    }
}
