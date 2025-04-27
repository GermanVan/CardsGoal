import UIKit

class AddTaskCell: UITableViewCell {
    let addButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(addButton)

        addButton.setTitle("Добавить задачу", for: .normal)
        addButton.backgroundColor = .systemGray5
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

