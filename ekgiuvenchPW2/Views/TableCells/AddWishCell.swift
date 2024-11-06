import UIKit

final class AddWishCell: UITableViewCell {
    static let reuseId: String = "AddWishCell"
    
    // MARK: - Constants
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 10
        static let wrapOffsetV: CGFloat = 10
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
        static let placeholderText: String = "Write your wish..."
        
        static let textColor: UIColor = .black
        static let placeholderColor: UIColor = .lightGray
    }
    
    // MARK: - Fields
    private let wishText = UITextView()
    var addWish: ((String) -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupPlaceholder()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func resetText() {
        wishText.text = Constants.placeholderText
        wishText.textColor = Constants.placeholderColor
    }

    // MARK: Private methods
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap = UIView()
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        contentView.addSubview(wrap)
        
        wrap.pinTop(to: contentView.topAnchor, Constants.wrapOffsetV)
        wrap.pinBottom(to: contentView.bottomAnchor, Constants.wrapOffsetV)
        wrap.pinLeft(to: contentView.leadingAnchor, Constants.wrapOffsetH)
        wrap.pinRight(to: contentView.trailingAnchor, Constants.wrapOffsetH)
        
        wrap.addSubview(wishText)
        wishText.backgroundColor = .clear
        wishText.font = UIFont.systemFont(ofSize: 16)
        wishText.isScrollEnabled = false
        wishText.delegate = self
        wishText.textColor = Constants.textColor
        wishText.isUserInteractionEnabled = true
        
        wishText.pin(to: wrap, Constants.wishLabelOffset)
    }
    
    private func setupPlaceholder() {
        wishText.text = Constants.placeholderText
        wishText.textColor = Constants.placeholderColor
    }
}

// MARK: - Extension
extension AddWishCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if wishText.text == Constants.placeholderText {
            wishText.text = nil
            wishText.textColor = Constants.textColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if wishText.text.isEmpty {
            setupPlaceholder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        addWish?(textView.text)
    }
}
