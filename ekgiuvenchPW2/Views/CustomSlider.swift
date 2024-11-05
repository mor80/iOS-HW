import UIKit

final class CustomSlider: UIView {
    // MARK: - Constants
    enum Constants {
        static let leadingConstraint: CGFloat = 20
        static let trailingConstraint: CGFloat = 20
        static let topConstraint: CGFloat = 20
        static let bottomConstraint: CGFloat = 20
        static let tintColor: UIColor = .darkGray
        static let shadowScale: CGFloat = 1
    }
    
    // MARK: - Fields
    var valueChanged: ((Float) -> Void)?
    
    var slider = UISlider()
    var titleView = UILabel()
    var valueView = UILabel()
    
    init(title: String, textColor: UIColor = .gray, min: Float = 0.0, max: Float = 255.0) {
        super.init(frame: .zero)
        titleView.text = title
        titleView.textColor = textColor
        titleView.shadowColor = .black
        titleView.shadowOffset = .init(width: Constants.shadowScale, height: Constants.shadowScale)
        
        valueView.textColor = textColor
        valueView.textAlignment = .right
        valueView.shadowColor = .black
        valueView.shadowOffset = .init(width: Constants.shadowScale, height: Constants.shadowScale)
        
        slider.tintColor = Constants.tintColor
        slider.minimumValue = min
        slider.maximumValue = max
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configureUI() {
        for view in [slider, titleView, valueView] {
            addSubview(view)
        }
        
        titleView.pinTop(to: topAnchor, Constants.topConstraint)
        titleView.pinLeft(to: leadingAnchor, Constants.leadingConstraint)
        titleView.pinRight(to: centerXAnchor)
        
        valueView.pinTop(to: topAnchor, Constants.topConstraint)
        valueView.pinLeft(to: centerXAnchor)
        valueView.pinRight(to: trailingAnchor, Constants.trailingConstraint)
        valueView.pinCenterY(to: titleView.centerYAnchor)
        
        slider.pinTop(to: titleView.bottomAnchor)
        slider.pinLeft(to: leadingAnchor, Constants.leadingConstraint)
        slider.pinCenterX(to: centerXAnchor)
        slider.pinBottom(to: bottomAnchor, Constants.bottomConstraint)
    }
    
    // MARK: - Actions
    @objc
    private func sliderValueChanged() {
        let value = slider.value
        valueChanged?(value)
        valueView.text = "\(Int(value))"
    }
}
