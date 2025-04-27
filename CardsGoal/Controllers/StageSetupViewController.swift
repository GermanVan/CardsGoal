import UIKit

class StageSetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let startGameButton = UIButton(type: .system)
    private let addStageButton = UIButton(type: .system)
    private var stageNames: [String] = [""]
    private var stageTasks: [[String]] = [[""]]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройка шагов"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StageNameCell.self, forCellReuseIdentifier: "StageNameCell")
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.register(AddTaskCell.self, forCellReuseIdentifier: "AddTaskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        startGameButton.setTitle("Начать игру", for: .normal)
        startGameButton.backgroundColor = .systemBlue
        startGameButton.setTitleColor(.white, for: .normal)
        startGameButton.layer.cornerRadius = 12
        startGameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        view.addSubview(startGameButton)
        addStageButton.setTitle("Добавить шаг", for: .normal)
        addStageButton.backgroundColor = .systemGreen
        addStageButton.setTitleColor(.white, for: .normal)
        addStageButton.layer.cornerRadius = 12
        addStageButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addStageButton.translatesAutoresizingMaskIntoConstraints = false
        addStageButton.addTarget(self, action: #selector(addStageButtonTapped), for: .touchUpInside)
        view.addSubview(addStageButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addStageButton.topAnchor, constant: -10),
            addStageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addStageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addStageButton.bottomAnchor.constraint(equalTo: startGameButton.topAnchor, constant: -10),
            addStageButton.heightAnchor.constraint(equalToConstant: 44),
            startGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            startGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func addStageButtonTapped() {
        stageNames.append("")
        stageTasks.append([""])
        tableView.reloadData()
    }

    @objc func startGameButtonTapped() {
        while !stageNames.isEmpty && stageNames.last?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            stageNames.removeLast()
            stageTasks.removeLast()
        }
        guard !stageNames.isEmpty else {
            showAlert(message: "Пожалуйста, добавьте хотя бы один шаг")
            return
        }
        guard !stageNames.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
            showAlert(message: "Пожалуйста, заполните названия всех шагов")
            return
        }
        for (index, tasks) in stageTasks.enumerated() {
            let currentTasks = tasks.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            if currentTasks.isEmpty {
                 showAlert(message: "Пожалуйста, добавьте и заполните хотя бы одну задачу для шага \(index + 1)")
                 return
            }
            let existingTaskFields = tasks
            if currentTasks.count < existingTaskFields.count {
                 showAlert(message: "Пожалуйста, заполните названия всех задач для шага \(index + 1)")
                 return
            }
        }
        createStages()
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }

    private func createStages() {
        GameManager.shared.stages = []
        for (index, stageName) in stageNames.enumerated() {
            var tasks: [Task] = []
            let smallTasks = stageTasks[index].filter { !$0.isEmpty }
            for taskTitle in smallTasks {
                let task = Task(title: taskTitle, level: .small)
                tasks.append(task)
            }
            let mediumTask = Task(title: stageName, level: .medium)
            tasks.append(mediumTask)
            let stage = Stage(title: stageName, tasks: tasks)
            GameManager.shared.stages.append(stage)
        }
        if let goal = GameManager.shared.goal {
            var lastStage = GameManager.shared.stages.last!
            lastStage.tasks.append(goal)
            GameManager.shared.stages[GameManager.shared.stages.count - 1] = lastStage
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return stageNames.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + stageTasks[section].count + (stageTasks[section].count < 8 ? 1 : 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StageNameCell", for: indexPath) as! StageNameCell
            cell.nameTextField.text = stageNames[section]
            cell.nameTextField.placeholder = "Название шага \(section + 1)"
            cell.nameTextField.tag = section
            cell.nameTextField.delegate = self
            cell.deleteButton.tag = section
            cell.deleteButton.addTarget(self, action: #selector(deleteStageButtonTapped(_:)), for: .touchUpInside)
            cell.deleteButton.isHidden = stageNames.count <= 1
            return cell
        } else if indexPath.row <= stageTasks[section].count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            let taskIndex = indexPath.row - 1
            cell.taskTextField.text = stageTasks[section][taskIndex]
            cell.taskTextField.placeholder = "Задача \(taskIndex + 1)"
            cell.taskTextField.tag = 1000 + section * 100 + taskIndex
            cell.taskTextField.delegate = self
            cell.deleteButton.tag = 1000 + section * 100 + taskIndex
            cell.deleteButton.addTarget(self, action: #selector(deleteTaskButtonTapped(_:)), for: .touchUpInside)
            cell.deleteButton.isHidden = stageTasks[section].count <= 1
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskCell", for: indexPath) as! AddTaskCell
            cell.addButton.isHidden = stageTasks[section].count >= 8
            cell.addButton.tag = section
            cell.addButton.addTarget(self, action: #selector(addTaskButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }

    @objc func addTaskButtonTapped(_ sender: UIButton) {
        let stageIndex = sender.tag
        guard stageIndex < stageTasks.count else { return }
        if stageTasks[stageIndex].count < 8 {
            stageTasks[stageIndex].append("")
            tableView.reloadData()
        }
    }

    @objc func deleteTaskButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        let stageIndex = (tag - 1000) / 100
        let taskIndex = (tag - 1000) % 100
        guard stageIndex < stageTasks.count, taskIndex < stageTasks[stageIndex].count else { return }
        stageTasks[stageIndex].remove(at: taskIndex)
        tableView.reloadData()
    }

    @objc func deleteStageButtonTapped(_ sender: UIButton) {
        let stageIndex = sender.tag
        guard stageNames.count > 1 else {
             showAlert(message: "Должен остаться хотя бы один шаг.")
             return
        }
        guard stageIndex < stageNames.count, stageIndex < stageTasks.count else { return }
        stageNames.remove(at: stageIndex)
        stageTasks.remove(at: stageIndex)
        tableView.reloadData()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag < 1000 {
            let stageIndex = tag
            if stageIndex < stageNames.count {
                stageNames[stageIndex] = textField.text ?? ""
            }
        } else {
            let adjustedTag = tag - 1000
            let stageIndex = adjustedTag / 100
            let taskIndex = adjustedTag % 100
            if stageIndex < stageTasks.count && taskIndex < stageTasks[stageIndex].count {
                stageTasks[stageIndex][taskIndex] = textField.text ?? ""
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

