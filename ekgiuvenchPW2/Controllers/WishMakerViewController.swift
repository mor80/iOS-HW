import UIKit

final class WishMakerViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let stackBottomConstraint: CGFloat = 80
        static let stackLeadingConstraint: CGFloat = 20
        
        static let labelWidth: CGFloat = 85
        static let labelHeight: CGFloat = 30
        
        static let titleTopConstraint: CGFloat = 10
        static let titleLeadingConstraint: CGFloat = 30
        static let titleFontSize: CGFloat = 32
        
        static let descriptionFontSize: CGFloat = 16
        static let shadowScale: CGFloat = 1
        static let shadowRadius: CGFloat = 0.5
        
        static let toggleButtonBottomConstraint: CGFloat = 20
        static let toggleButtonHeight: CGFloat = 44
        static let toggleButtonWidth: CGFloat = 90
        
        static let buttonCornerRadius: CGFloat = 20
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
    private var buttonTitleValue = Constants.hidePromt
    
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
    }
    
    // MARK: - Configure Text
    private func configureText() {
        for text in [titleView, descriptionView] {
            text.textColor = .white
            text.shadowColor = .black
            text.shadowOffset = CGSize(width: Constants.shadowScale, height: Constants.shadowScale)
            text.textAlignment = .center
            
            view.addSubview(text)
        }
        
        configureTitle()
        configureDescription()
    }
    
    private func configureTitle() {
        titleView.text = "WishMaker"
        titleView.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        
        titleView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopConstraint)
        titleView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.titleLeadingConstraint)
        titleView.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
    }
    
    private func configureDescription() {
        descriptionView.text = "Make your dreams come true"
        descriptionView.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize, weight: .bold)
                
        descriptionView.pinTop(to: titleView.bottomAnchor, Constants.titleTopConstraint)
        descriptionView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.titleLeadingConstraint)
        descriptionView.pinCenterX(to: titleView.centerXAnchor)
    }
    
    // MARK: - Configure Selectors
    private func configureRGBColorSelector() {
        view.addSubview(rgbColorSelector)
        
        rgbColorSelector.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.stackBottomConstraint)
        rgbColorSelector.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.stackLeadingConstraint)
        rgbColorSelector.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        
        rgbColorSelector.onColorChange = { [weak self] color in
            self?.view.backgroundColor = color
        }
        view.backgroundColor = rgbColorSelector.color
    }
    
    // MARK: - Configure Buttons
    private func configureButtons() {
        for button in [toggleButton, addWishButton] {
            button.backgroundColor = .white.withAlphaComponent(Constants.defaultAlpha)
            button.layer.borderColor = Constants.borderColor
            button.layer.borderWidth = Constants.buttonBorderWidth
            button.layer.cornerRadius = Constants.buttonCornerRadius
            
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.layer.shadowColor = UIColor.black.cgColor
            button.titleLabel?.layer.shadowRadius = Constants.shadowRadius
            button.titleLabel?.layer.shadowOpacity = Float(Constants.shadowScale)
            button.titleLabel?.layer.shadowOffset = CGSize(width: Constants.shadowScale, height: Constants.shadowScale)
            
            button.addTarget(self, action: #selector(buttonTouchDown(_ :)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_ :)), for: [.touchUpInside, .touchUpOutside])
            
            view.addSubview(button)
        }
        
        configureToggleButton()
        configureAddWishButton()
    }
    
    private func configureToggleButton() {
        toggleButton.setTitle(buttonTitleValue, for: .normal)
        
        toggleButton.pinBottom(to: rgbColorSelector.topAnchor, Constants.toggleButtonBottomConstraint)
        toggleButton.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        toggleButton.setHeight(Constants.toggleButtonHeight)
        toggleButton.setWidth(Constants.toggleButtonWidth)
        
        toggleButton.addTarget(self, action: #selector(toggleRGBColorSelector), for: .touchUpInside)
        toggleButton.addTarget(self, action: #selector(toggleButtonTitle), for: .touchDown)
    }
    
    private func configureAddWishButton() {
        addWishButton.setTitle("Wishes", for: .normal)
        
        addWishButton.pinTop(to: rgbColorSelector.bottomAnchor, Constants.toggleButtonBottomConstraint)
        addWishButton.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        addWishButton.setHeight(Constants.toggleButtonHeight)
        addWishButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.stackLeadingConstraint)
        
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchDown)
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
        UIView.animate(withDuration: Constants.animationDuration) {
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
        present(WishStoringViewController(), animated: true)
        self.addWishButton.transform = .identity
        self.addWishButton.alpha = 1
    }
}
