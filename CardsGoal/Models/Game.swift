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
        guard let stage = currentStage else { return 0 }
        guard let taskIndex = stage.tasks.firstIndex(where: { $0.id == taskId }) else { return 0 }
        if !stage.tasks[taskIndex].isCompleted {
            guard let stageIndex = stages.firstIndex(where: { $0.id == stage.id }) else { return 0 }
            stages[stageIndex].tasks[taskIndex].isCompleted = true
            score += stages[stageIndex].tasks[taskIndex].points
            return stages[stageIndex].tasks[taskIndex].points
        }
        return 0
    }
    
    func uncompleteTask(_ taskId: UUID) -> Int {
        guard let stage = currentStage else { return 0 }
        guard let taskIndex = stage.tasks.firstIndex(where: { $0.id == taskId }) else { return 0 }
        if stage.tasks[taskIndex].isCompleted {
            guard let stageIndex = stages.firstIndex(where: { $0.id == stage.id }) else { return 0 }
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
    
    func areAllSmallTasksCompleted() -> Bool {
        guard let stage = currentStage else { return false }
        let smallTasks = stage.tasks.filter { $0.level == .small }
        return !smallTasks.isEmpty && smallTasks.allSatisfy { $0.isCompleted }
    }
    
    func completeMediumTask() {
        guard currentStageIndex < stages.count else { return }
        if canCompleteCurrentMediumTask() {
            guard let currentStageRef = currentStage,
                  let mediumTask = currentStageRef.mediumTask,
                  let taskIndex = currentStageRef.tasks.firstIndex(where: { $0.id == mediumTask.id }),
                  let stageIndex = stages.firstIndex(where: { $0.id == currentStageRef.id })
            else { return }
            
            if score >= mediumTask.points && !mediumTask.isCompleted {
                guard let stageIndex = stages.firstIndex(where: { $0.id == currentStageRef.id }) else { return }
                
                stages[stageIndex].tasks[taskIndex].isCompleted = true
                stages[stageIndex].isCompleted = true
                score -= currentStageRef.requiredPointsForCompletion
            }
        }
    }
    func canCompleteCurrentMediumTask() -> Bool {
        guard let stage = currentStage,
              let mediumTask = stage.mediumTask,
              !mediumTask.isCompleted else {
            return false
        }
        let allSmallCompleted = areAllSmallTasksCompleted()
        let hasEnoughPoints = score >= stage.requiredPointsForCompletion
        return allSmallCompleted && hasEnoughPoints
    }
    func reset() {
        goal = nil
        stages = []
        currentStageIndex = 0
        score = 0
    }
}

