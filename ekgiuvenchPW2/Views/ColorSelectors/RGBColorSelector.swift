import UIKit

final class RGBColorSelector: UIView {
    // MARK: - Constants
    private enum Constants {
        static let stackCornerRadius: CGFloat = 20
        static let stackBorderWidth: CGFloat = 2
        static let stackbackgroundColor: UIColor = .systemGray4
        static let stackBorderColor: CGColor = .init(red: 63/255, green: 66/255, blue: 80/255, alpha: 1)
        
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        
        static let redColor: UIColor = .systemGray4
        static let greenColor: UIColor = .systemGray4
        static let blueColor: UIColor = .systemGray4
        
        static let defaultColorValue: Float = 0.0
    }
    
    // MARK: - Fields
    var onColorChange: ((UIColor) -> Void)?
    
    var red: Float = Constants.defaultColorValue
    var green: Float = Constants.defaultColorValue
    var blue: Float = Constants.defaultColorValue
    
    private let redSlider: CustomSlider = CustomSlider(title: Constants.red, textColor: Constants.redColor)
    private let greenSlider: CustomSlider = CustomSlider(title: Constants.green, textColor: Constants.greenColor)
    private let blueSlider: CustomSlider = CustomSlider(title: Constants.blue,textColor: Constants.blueColor)
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        
        stack.layer.cornerRadius = Constants.stackCornerRadius
        stack.layer.borderWidth = Constants.stackBorderWidth
        stack.layer.borderColor = Constants.stackBorderColor
        stack.backgroundColor = Constants.stackbackgroundColor
        
        stack.axis = .vertical
        stack.clipsToBounds = true
        
        return stack
    }()
    
    // MARK: - Properties
    var hexColor: String {
        return String(format: "#%02X%02X%02X", Int(red), Int(green), Int(blue))
    }
    
    var color: UIColor {
        return UIColor(hexColor: hexColor)!
    }
    
    // MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func updateTextColor(with color: UIColor) {
        redSlider.updateTextColor(with: color)
        greenSlider.updateTextColor(with: color)
        blueSlider.updateTextColor(with: color)
    }
    
    // MARK: - Private methods
    private func configureUI() {
        self.addSubview(stackView)
        
        stackView.pinCenter(to: self)
        stackView.pinLeft(to: leadingAnchor)
        stackView.pinTop(to: topAnchor)
        
        for slider in [redSlider, greenSlider, blueSlider] {
            stackView.addArrangedSubview(slider)
            slider.valueChanged = { [weak self] value in
                switch slider {
                case self?.redSlider:
                    self?.red = value
                case self?.greenSlider:
                    self?.green = value
                case self?.blueSlider:
                    self?.blue = value
                default: break
                }
                self?.onColorChange?(self!.color)
            }
        }
    }
}
