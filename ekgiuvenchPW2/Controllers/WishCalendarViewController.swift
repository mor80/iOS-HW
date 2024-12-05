import UIKit
import EventKit

final class WishCalendarViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let contentInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        static let spacing: CGFloat = 10
        static let cellsPerRow: CGFloat = 2
        static let cellHeight: CGFloat = 150
        static let addButtonSize: CGFloat = 50
        static let titleFont: UIFont = .boldSystemFont(ofSize: 24)
        static let titleTopPadding: CGFloat = 10
        static let titleFontSize: CGFloat = 32
        static let shadowScale: CGFloat = 1
        static let shadowRadius: CGFloat = 0.5
        static let eventsKey: String = "savedEvents"

    }
    
    // MARK: - Properties
    var initialColor: UIColor? {
        didSet {
            view.backgroundColor = initialColor
            collectionView.backgroundColor = initialColor
            addButton.setTitleColor(initialColor, for: .normal)
        }
    }
    
    private let calendarManager = CalendarManager() // CalendarManager для работы с календарем
    private var events: [WishEventModel] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Events"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.spacing
        layout.minimumInteritemSpacing = Constants.spacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        button.layer.cornerRadius = Constants.addButtonSize / 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = initialColor ?? .white
        loadEvents()
        configureTitleLabel()
        configureCollection()
        configureAddButton()
        observeNewEvents()
    }

    // MARK: - Private Methods
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.shadowColor = .black
        titleLabel.shadowOffset = CGSize(width: Constants.shadowScale, height: Constants.shadowScale)
        titleLabel.textAlignment = .center
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopPadding)
        titleLabel.pinHorizontal(to: view, Constants.spacing)
    }

    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = Constants.contentInset
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.pinTop(to: titleLabel.bottomAnchor, Constants.spacing)
        collectionView.pinHorizontal(to: view)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 20)
        addButton.pinRight(to: view.trailingAnchor, 20)
        addButton.setWidth(Constants.addButtonSize)
        addButton.setHeight(Constants.addButtonSize)

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    private func observeNewEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewEvent(_:)), name: .newEventCreated, object: nil)
    }

    private func saveEvents() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(events) {
            UserDefaults.standard.set(encodedData, forKey: Constants.eventsKey)
        }
    }

    private func loadEvents() {
        guard let savedData = UserDefaults.standard.data(forKey: Constants.eventsKey) else { return }
        let decoder = JSONDecoder()
        if let savedEvents = try? decoder.decode([WishEventModel].self, from: savedData) {
            events = savedEvents
        }
    }
    
    private func getWishes() -> [String] {
        if let savedWishes = UserDefaults.standard.array(forKey: "wishKey") as? [String] {
            return savedWishes
        }
        return []
    }

    // MARK: - Actions
    @objc private func addButtonTapped() {
        let creationVC = WishEventCreationView()
        creationVC.initialColor = initialColor
        creationVC.wishes = getWishes()
        present(creationVC, animated: true)
        
        self.addButton.transform = .identity
        self.addButton.alpha = 1
    }

    @objc
    private func handleNewEvent(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo["title"] as? String,
              let description = userInfo["description"] as? String,
              let startDate = userInfo["startDate"] as? Date,
              let endDate = userInfo["endDate"] as? Date else { return }

        let newEvent = WishEventModel(
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate
        )

        events.append(newEvent)
        collectionView.reloadData()
        saveEvents()

        let calendarEventModel = CalendarEventModel(
            title: newEvent.title,
            startDate: newEvent.startDate,
            endDate: newEvent.endDate,
            note: newEvent.description
        )

        // Используем CalendarManager для добавления события
        calendarManager.create(eventModel: calendarEventModel) { isCreated in
            if isCreated {
                print("Event successfully added to calendar.")
            } else {
                print("Failed to add event to calendar.")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath) as? WishEventCell else {
            return UICollectionViewCell()
        }
        
        let event = events[indexPath.item]
        cell.configure(with: event)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = Constants.spacing * (Constants.cellsPerRow - 1) + Constants.contentInset.left + Constants.contentInset.right
        let width = (collectionView.bounds.width - totalSpacing) / Constants.cellsPerRow
        return CGSize(width: width, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped on event at index \(indexPath.item): \(events[indexPath.item].title)")
    }
}
