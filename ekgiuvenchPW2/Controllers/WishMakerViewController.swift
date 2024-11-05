import UIKit

class WishMakerViewController: UIViewController {
    // MARK: - Constants
    enum Constants {
        static let stackBottomConstraint: CGFloat = 70
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
    let titleView = UILabel()
    let descriptionView = UILabel()
    let toggleButton = UIButton()
    var rgbColorSelector = RGBColorSelector()
    var buttonTitleValue = Constants.hidePromt
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private methods
    private func configureUI() {
        configureTitle()
        configureDescription()
        configureRGBColorSelector()
        configureToggleButton()
    }
    
    private func configureTitle() {
        titleView.text = "WishMaker"
        titleView.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        titleView.textColor = .white
        titleView.shadowColor = .black
        titleView.shadowOffset = .init(width: Constants.shadowScale, height: Constants.shadowScale)
        titleView.textAlignment = .center
        
        view.addSubview(titleView)
        
        titleView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopConstraint)
        titleView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.titleLeadingConstraint)
        titleView.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
    }
    
    private func configureDescription() {
        descriptionView.text = "Make your dreams come true"
        descriptionView.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize, weight: .bold)
        descriptionView.textColor = .white
        descriptionView.shadowColor = .black
        descriptionView.shadowOffset = .init(width: Constants.shadowScale, height: Constants.shadowScale)
        descriptionView.textAlignment = .center
        
        view.addSubview(descriptionView)
        
        descriptionView.pinTop(to: titleView.bottomAnchor, Constants.titleTopConstraint)
        descriptionView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.titleLeadingConstraint)
        descriptionView.pinCenterX(to: titleView.centerXAnchor)
    }
    
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
    
    private func configureToggleButton() {
        toggleButton.setTitle(buttonTitleValue, for: .normal)
        
        toggleButton.backgroundColor = .white.withAlphaComponent(Constants.defaultAlpha)
        toggleButton.layer.borderColor = Constants.borderColor
        toggleButton.layer.borderWidth = Constants.buttonBorderWidth
        toggleButton.layer.cornerRadius = Constants.buttonCornerRadius
        
        toggleButton.setTitleColor(.white, for: .normal)
        toggleButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        toggleButton.titleLabel?.layer.shadowRadius = Constants.shadowRadius
        toggleButton.titleLabel?.layer.shadowOpacity = Float(Constants.shadowScale)
        toggleButton.titleLabel?.layer.shadowOffset = CGSize(width: Constants.shadowScale, height: Constants.shadowScale)
        
        view.addSubview(toggleButton)
        
        toggleButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.toggleButtonBottomConstraint)
        toggleButton.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        toggleButton.setHeight(Constants.toggleButtonHeight)
        toggleButton.setWidth(Constants.toggleButtonWidth)
        
        toggleButton.addTarget(self, action: #selector(toggleRGBColorSelector), for: .touchUpInside)
        toggleButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        toggleButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    // MARK: - Actions
    @objc
    private func buttonTouchDown() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.toggleButton.transform = CGAffineTransform(scaleX: Constants.x, y: Constants.y)
            self.toggleButton.alpha = Constants.defaultAlpha
        }

        if buttonTitleValue.hasPrefix("S") {
            buttonTitleValue = Constants.hidePromt
        }
        else {
            buttonTitleValue = Constants.showPromt
        }
        
        toggleButton.setTitle(self.buttonTitleValue, for: .normal)
    }
    
    @objc
    private func buttonTouchUp() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.toggleButton.transform = .identity
            self.toggleButton.alpha = 1
        }
    }
    
    @objc
    private func toggleRGBColorSelector() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.rgbColorSelector.isHidden.toggle()
        }
    }
}
