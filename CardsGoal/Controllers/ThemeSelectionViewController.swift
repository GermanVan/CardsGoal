import UIKit

class ThemeSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let titleLabel = UILabel()
    private var collectionView: UICollectionView!
    private let nextButton = UIButton(type: .system)
    private var selectedThemeIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleLabel.text = "Выберите цветовую тему"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ThemeCell.self, forCellWithReuseIdentifier: "ThemeCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        nextButton.setTitle("Далее", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 12
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.heightAnchor.constraint(equalToConstant: 350),
            nextButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            nextButton.heightAnchor.constraint(equalToConstant: 55),
            nextButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc private func nextButtonTapped() {
        GameManager.shared.selectedTheme = ColorTheme.themes[selectedThemeIndex]
        let stageVC = StageSetupViewController()
        navigationController?.pushViewController(stageVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorTheme.themes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
        let theme = ColorTheme.themes[indexPath.item]
        cell.configure(with: theme, selected: indexPath.item == selectedThemeIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedThemeIndex = indexPath.item
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
}

class ThemeCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let smallView = UIView()
    private let mediumView = UIView()
    private let globalView = UIView()
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.backgroundColor = .systemGray6
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        smallView.layer.cornerRadius = 8
        mediumView.layer.cornerRadius = 8
        globalView.layer.cornerRadius = 8
        smallView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        globalView.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(smallView)
        stack.addArrangedSubview(mediumView)
        stack.addArrangedSubview(globalView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            smallView.widthAnchor.constraint(equalToConstant: 30),
            smallView.heightAnchor.constraint(equalToConstant: 30),
            mediumView.widthAnchor.constraint(equalToConstant: 30),
            mediumView.heightAnchor.constraint(equalToConstant: 30),
            globalView.widthAnchor.constraint(equalToConstant: 30),
            globalView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    func configure(with theme: ColorTheme, selected: Bool) {
        nameLabel.text = theme.name
        smallView.backgroundColor = theme.smallTaskColor
        mediumView.backgroundColor = theme.mediumTaskColor
        globalView.backgroundColor = theme.globalTaskColor
        contentView.layer.borderColor = selected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
    }
}
