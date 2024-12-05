import UIKit

final class WishMakerViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let stackBottomConstraint: CGFloat = 40
        static let stackLeadingConstraint: CGFloat = 20
        static let stackHeight: CGFloat = 100
        static let spacing: CGFloat = 15

        static let labelWidth: CGFloat = 85
        static let labelHeight: CGFloat = 30
        
        static let titleTopConstraint: CGFloat = 10
        static let titleLeadingConstraint: CGFloat = 30
        static let titleFontSize: CGFloat = 32
        
        static let descriptionTopSpacing: CGFloat = 10
        static let descriptionFontSize: CGFloat = 16
        static let shadowScale: CGFloat = 1
        static let shadowRadius: CGFloat = 0.5
        
        static let toggleButtonBottomConstraint: CGFloat = 20
        static let toggleButtonHeight: CGFloat = 44

        static let toggleButtonWidth: CGFloat = 90
        
        static let buttonCornerRadius: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let buttonBorderWidth: CGFloat = 2
        
        static let animationDuration: CGFloat = 0.1
        static let defaultAlpha: CGFloat = 0.5
        static let x: CGFloat = 0.95
        static let y: CGFloat = 0.95

        static let borderColor: CGColor = .init(red: 63/255, green: 66/255, blue: 80/255, alpha: 1)
        
        static let hidePromt: String = "Hide"
        static let showPromt: String = "Show"
    }
    
    // MARK: - Fields
    private let titleView = UILabel()
    private let descriptionView = UILabel()
    private let toggleButton = UIButton(type: .system)
    private let addWishButton = UIButton(type: .system)
    private let rgbColorSelector = RGBColorSelector()
    private let actionStack = UIStackView()
    private let scheduleWishesButton = UIButton(type: .system)
    
    private let calendarVC = WishCalendarViewController()
    private let wishVC = WishStoringViewController()

    
    private var buttonTitleValue = Constants.hidePromt
    
    // MARK: - Properties
    var color: UIColor = .black {
        didSet {
            view.backgroundColor = color
            updateButtonTitleColors(with: color)
            rgbColorSelector.updateTextColor(with: color)
        }
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private methods
    private func configureUI() {
        configureText()
        configureRGBColorSelector()
        configureButtons()
        configureActionStack()
        updateButtonTitleColors(with: color)
        rgbColorSelector.updateTextColor(with: color)
    }
    
    private func updateButtonTitleColors(with color: UIColor) {
        addWishButton.setTitleColor(color, for: .normal)
        scheduleWishesButton.setTitleColor(color, for: .normal)
        toggleButton.setTitleColor(color, for: .normal)
    }
    
    // MARK: - Configure Text
    private func configureText() {
        titleView.text = "WishMaker"
        titleView.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        descriptionView.text = "Make your dreams come true"
        descriptionView.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        
        for text in [titleView, descriptionView] {
            text.textColor = .white
            text.shadowColor = .black
            text.shadowOffset = CGSize(width: Constants.shadowScale, height: Constants.shadowScale)
            text.textAlignment = .center
            
            view.addSubview(text)
        }

        titleView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopConstraint)
        titleView.pinHorizontal(to: view, Constants.titleLeadingConstraint)

        descriptionView.pinTop(to: titleView.bottomAnchor, Constants.descriptionTopSpacing)
        descriptionView.pinHorizontal(to: view, Constants.titleLeadingConstraint)
    }
    
    // MARK: - Configure Selectors
    private func configureRGBColorSelector() {
        view.addSubview(rgbColorSelector)
        
        rgbColorSelector.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.stackBottomConstraint + Constants.stackHeight + Constants.spacing)
        rgbColorSelector.pinHorizontal(to: view, Constants.stackLeadingConstraint)
        
        rgbColorSelector.onColorChange = { [weak self] color in
            self?.color = color
        }
        view.backgroundColor = rgbColorSelector.color
    }
    
    // MARK: - Configure Buttons
    private func configureButtons() {
        configureAddWishButton()
        configureScheduleMissions()
        configureToggleButton()
    }
    
    private func configureActionStack() {
        actionStack.axis = .vertical
        actionStack.spacing = Constants.spacing
        actionStack.alignment = .fill
        actionStack.distribution = .fillEqually

        actionStack.addArrangedSubview(addWishButton)
        actionStack.addArrangedSubview(scheduleWishesButton)

        view.addSubview(actionStack)
        actionStack.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.stackBottomConstraint)
        actionStack.pinHorizontal(to: view, Constants.stackLeadingConstraint)
        actionStack.setHeight(Constants.stackHeight)
    }
    
    private func configureToggleButton() {
        toggleButton.setTitle(buttonTitleValue, for: .normal)
        styleButton(toggleButton)
        
        view.addSubview(toggleButton)
        
        toggleButton.pinBottom(to: rgbColorSelector.topAnchor, Constants.toggleButtonBottomConstraint)
        toggleButton.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        toggleButton.setHeight(Constants.toggleButtonHeight)
        toggleButton.setWidth(Constants.toggleButtonWidth)
        
        
        toggleButton.addTarget(self, action: #selector(toggleRGBColorSelector), for: .touchUpInside)
        toggleButton.addTarget(self, action: #selector(toggleButtonTitle), for: .touchUpInside)
    }
    
    private func configureAddWishButton() {
        addWishButton.setTitle("Add wishes", for: .normal)
        styleButton(addWishButton)
        
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    private func configureScheduleMissions() {
        scheduleWishesButton.setTitle("Schedule wishes", for: .normal)
        styleButton(scheduleWishesButton)
        
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishesButtonPressed), for: .touchUpInside)
    }
    
    // MARK: Style buttons
    private func styleButton(_ button: UIButton) {
        button.backgroundColor = .systemGray4
        button.layer.borderColor = Constants.borderColor
        button.layer.borderWidth = Constants.buttonBorderWidth
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.layer.shadowColor = UIColor.black.cgColor
//        button.titleLabel?.layer.shadowRadius = Constants.shadowRadius
//        button.titleLabel?.layer.shadowOpacity = Float(Constants.shadowScale)
//        button.titleLabel?.layer.shadowOffset = CGSize(width: Constants.shadowScale, height: Constants.shadowScale)
//        
        button.addTarget(self, action: #selector(buttonTouchDown(_ :)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_ :)), for: [.touchUpInside, .touchUpOutside])
    }
    
    
    // MARK: - Actions
    // MARK: Actions for all buttons
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
    
    // MARK: Actions for toggleButton
    @objc
    private func toggleRGBColorSelector() {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.rgbColorSelector.alpha = self.rgbColorSelector.isHidden ? 1 : 0
        }) { _ in
            self.rgbColorSelector.isHidden.toggle()
        }
    }
    
    @objc
    private func toggleButtonTitle() {
        if buttonTitleValue.hasPrefix("S") {
            buttonTitleValue = Constants.hidePromt
        }
        else {
            buttonTitleValue = Constants.showPromt
        }
        
        toggleButton.setTitle(self.buttonTitleValue, for: .normal)
    }
    
    
    // MARK: - Actions for addWishButton
    @objc
    private func addWishButtonPressed() {
        wishVC.initialColor = color // Передаём текущий цвет
        present(wishVC, animated: true)
    
        self.addWishButton.transform = .identity
        self.addWishButton.alpha = 1
    }
    
    // MARK: - Actions for scheduleWishButton
    @objc
    private func scheduleWishesButtonPressed() {
        print("Schedule Wishes Button Pressed")

        calendarVC.initialColor = color // Передаём текущий цвет
        navigationController?.pushViewController(calendarVC, animated: true)
        
        self.scheduleWishesButton.transform = .identity
        self.scheduleWishesButton.alpha = 1
    }
}
