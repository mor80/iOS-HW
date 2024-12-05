import UIKit

final class WishEventCell: UICollectionViewCell {
    // MARK: - Constants
    static let reuseIdentifier: String = "WishEventCell"
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let backgroundColor: UIColor = .white
        static let shadowColor: UIColor = .black
        static let shadowOpacity: Float = 0.2
        static let shadowOffset: CGSize = .init(width: 0, height: 2)
        static let shadowRadius: CGFloat = 4
        
        static let titleFont: UIFont = .boldSystemFont(ofSize: 16)
        static let descriptionFont: UIFont = .systemFont(ofSize: 14)
        static let dateFont: UIFont = .italicSystemFont(ofSize: 12)
        
        static let offset: CGFloat = 10
    }
    
    // MARK: - Fields
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with event: WishEventModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // Если начальная дата больше конечной, устанавливаем их равными
        var startDate = event.startDate
        let endDate = event.endDate
        if startDate > endDate {
            startDate = endDate
        }
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = "Start: \(startDateString)"
        endDateLabel.text = "End: \(endDateString)"
    }
    
    // MARK: - Private Methods
    private func configureWrap() {
        addSubview(wrapView)
        wrapView.backgroundColor = Constants.backgroundColor
        wrapView.layer.cornerRadius = Constants.cornerRadius
        wrapView.layer.shadowColor = Constants.shadowColor.cgColor
        wrapView.layer.shadowOpacity = Constants.shadowOpacity
        wrapView.layer.shadowOffset = Constants.shadowOffset
        wrapView.layer.shadowRadius = Constants.shadowRadius
        
        wrapView.pin(to: self, Constants.offset)
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .black
        
        titleLabel.pinTop(to: wrapView.topAnchor, Constants.offset)
        titleLabel.pinLeft(to: wrapView.leadingAnchor, Constants.offset)
        titleLabel.pinRight(to: wrapView.trailingAnchor, Constants.offset)
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.offset)
        descriptionLabel.pinLeft(to: wrapView.leadingAnchor, Constants.offset)
        descriptionLabel.pinRight(to: wrapView.trailingAnchor, Constants.offset)
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.font = Constants.dateFont
        startDateLabel.textColor = .gray
        
        startDateLabel.pinTop(to: descriptionLabel.bottomAnchor, Constants.offset)
        startDateLabel.pinLeft(to: wrapView.leadingAnchor, Constants.offset)
        startDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.offset)
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.font = Constants.dateFont
        endDateLabel.textColor = .gray
        
        endDateLabel.pinTop(to: startDateLabel.bottomAnchor, Constants.offset)
        endDateLabel.pinLeft(to: wrapView.leadingAnchor, Constants.offset)
        endDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.offset)
        endDateLabel.pinBottom(to: wrapView.bottomAnchor, Constants.offset)
    }
}
