import UIKit

final class WishStoringViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: CGFloat = 30
        static let closeButtonOffset: CGFloat = 5
        static let numberOfSections: Int = 2
        static let wishesKey: String = "wishKey"
        static let bottomConstraint: CGFloat = 40
        
        static let saveButtonBottomConstraint: CGFloat = 20
        static let saveButtonHeight: CGFloat = 44
        static let saveButtonWidth: CGFloat = 90
        
        static let shadowScale: CGFloat = 1
        static let shadowRadius: CGFloat = 0.5
        
        static let buttonCornerRadius: CGFloat = 20
        static let buttonBorderWidth: CGFloat = 2
        
        static let animationDuration: CGFloat = 0.1
        static let defaultAlpha: CGFloat = 0.5
        static let x: CGFloat = 0.95
        static let y: CGFloat = 0.95

        static let borderColor: CGColor = .init(red: 63/255, green: 66/255, blue: 80/255, alpha: 1)
    }
    
    // MARK: - Fields
    private var wishArray: [String] = []
    private let table: UITableView = UITableView(frame: .zero)
    private let closeButton: UIButton = UIButton(type: .close)
    private let saveWishButton: UIButton = UIButton(type: .system)
    private var currentWishText: String = ""
    private let defaults = UserDefaults.standard
    
    // MARK: - Methods
    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        configureUI()
        loadWishes()
    }
    
    // MARK: - Private methods
    private func configureUI() {
        configureTable()
        configureCloseButton()
        configureSaveWishButton()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .lightGray
        table.dataSource = self
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.separatorStyle = .none
        table.pinTop(to: view.topAnchor, Constants.tableOffset)
        table.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.bottomConstraint)
        table.pinLeft(to: view.leadingAnchor, Constants.tableOffset)
        table.pinRight(to: view.trailingAnchor, Constants.tableOffset)
        
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
    }
    
    private func configureCloseButton() {
        closeButton.backgroundColor = .white
        closeButton.layer.cornerRadius = closeButton.frame.height
        
        view.addSubview(closeButton)
        closeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.closeButtonOffset)
        closeButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.closeButtonOffset)

        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchDown)
    }
    
    private func configureSaveWishButton() {
        saveWishButton.setTitle("Save", for: .normal)
        saveWishButton.backgroundColor = .white.withAlphaComponent(Constants.defaultAlpha)
        saveWishButton.layer.borderColor = Constants.borderColor
        saveWishButton.layer.borderWidth = Constants.buttonBorderWidth
        saveWishButton.layer.cornerRadius = Constants.buttonCornerRadius
        
        saveWishButton.setTitleColor(.white, for: .normal)
        saveWishButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        saveWishButton.titleLabel?.layer.shadowRadius = Constants.shadowRadius
        saveWishButton.titleLabel?.layer.shadowOpacity = Float(Constants.shadowScale)
        saveWishButton.titleLabel?.layer.shadowOffset = CGSize(width: Constants.shadowScale, height: Constants.shadowScale)
        
        saveWishButton.addTarget(self, action: #selector(buttonTouchDown(_ :)), for: .touchDown)
        saveWishButton.addTarget(self, action: #selector(buttonTouchUp(_ :)), for: [.touchUpInside, .touchUpOutside])
        
        view.addSubview(saveWishButton)

        saveWishButton.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        saveWishButton.setHeight(Constants.saveButtonHeight)
        saveWishButton.setWidth(Constants.saveButtonWidth)
        saveWishButton.pinBottom(to: view.bottomAnchor, Constants.saveButtonBottomConstraint)
        
        saveWishButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchDown)
    }
    
    // MARK: Saving wishes
    private func saveWishes() {
        defaults.set(wishArray, forKey: Constants.wishesKey)
    }
    
    private func loadWishes() {
        if let savedWishes = defaults.array(forKey: Constants.wishesKey) as? [String] {
            wishArray = savedWishes
        }
    }

    // MARK: - Actions
    // MARK:  Actions for all buttons
    @objc
    private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: Constants.animationDuration) {
            sender.transform = CGAffineTransform(scaleX: Constants.x, y: Constants.y)
            sender.alpha = Constants.defaultAlpha
        }
    }
    
    @objc
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: Constants.animationDuration) {
            sender.transform = .identity
            sender.alpha = 1
        }
    }
    
    // MARK: Actions for closeButton
    @objc
    private func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    
    // MARK: Actions for saveButton
    @objc private func saveButtonPressed() {
        guard !currentWishText.isEmpty else { return }
        wishArray.append(currentWishText)
        currentWishText = ""
        saveWishes()

        if let addWishCell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddWishCell {
           addWishCell.resetText()
        }

        table.reloadData()
   }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : wishArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath)
            if let addWishCell = cell as? AddWishCell {
                addWishCell.addWish = { [weak self] text in
                    self?.currentWishText = text
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath)
            if let wishCell = cell as? WrittenWishCell {
                wishCell.configure(with: wishArray[indexPath.row])
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
}
