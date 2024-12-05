import UIKit

final class WishEventCreationView: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = .white

        static let textFieldHeight: CGFloat = 50
        static let textFieldCornerRadius: CGFloat = 10
        static let textFieldFont: UIFont = .systemFont(ofSize: 16)

        static let buttonHeight: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 10
        static let buttonFont: UIFont = .boldSystemFont(ofSize: 18)
        static let buttonBackgroundColor: UIColor = .systemGray2
        static let buttonTitleColor: UIColor = .black

        static let stackSpacing: CGFloat = 20
        static let stackPadding: CGFloat = 20
        static let dateLabelFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let dateLabelWidth: CGFloat = 100
    }

    // MARK: - Fields
    private let titleTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let saveButton = UIButton(type: .system)
    private let pickerView = UIPickerView()

    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Start date"
        label.font = Constants.dateLabelFont
        label.textAlignment = .right
        return label
    }()

    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "End date"
        label.font = Constants.dateLabelFont
        label.textAlignment = .right
        return label
    }()

    // MARK: - Properties
    var initialColor: UIColor?
    var wishes: [String] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = initialColor
        saveButton.setTitleColor(initialColor, for: .normal)

        if !wishes.isEmpty {
            pickerView.selectRow(0, inComponent: 0, animated: false)
            titleTextField.text = wishes[0]
        }
    }

    // MARK: - Methods
    private func configureUI() {
        configureTextField(titleTextField, placeholder: "Event Title")
        configureTextField(descriptionTextField, placeholder: "Event Description")

        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)

        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)

        saveButton.setTitle("Save Event", for: .normal)
        saveButton.backgroundColor = Constants.buttonBackgroundColor
        saveButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        saveButton.layer.cornerRadius = Constants.buttonCornerRadius
        saveButton.titleLabel?.font = Constants.buttonFont
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        let startDateStack = UIStackView(arrangedSubviews: [startDateLabel, startDatePicker])
        startDateStack.axis = .horizontal
        startDateStack.spacing = Constants.stackSpacing
        startDateLabel.setWidth(Constants.dateLabelWidth)

        let endDateStack = UIStackView(arrangedSubviews: [endDateLabel, endDatePicker])
        endDateStack.axis = .horizontal
        endDateStack.spacing = Constants.stackSpacing
        endDateLabel.setWidth(Constants.dateLabelWidth)

        let mainStackView = UIStackView(arrangedSubviews: [pickerView, titleTextField, descriptionTextField, startDateStack, endDateStack, saveButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = Constants.stackSpacing

        view.addSubview(mainStackView)
        mainStackView.pinHorizontal(to: view, Constants.stackPadding)
        mainStackView.pinCenterY(to: view)

        pickerView.dataSource = self
        pickerView.delegate = self
    }

    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Constants.backgroundColor
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.font = Constants.textFieldFont
        textField.setHeight(Constants.textFieldHeight)
    }

    // MARK: - Actions
    @objc private func startDateChanged() {
        if startDatePicker.date > endDatePicker.date {
            endDatePicker.date = startDatePicker.date
        }
    }

    @objc private func endDateChanged() {
        if endDatePicker.date < startDatePicker.date {
            startDatePicker.date = endDatePicker.date
        }
    }

    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please select or enter a title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let startDate = startDatePicker.date
        let endDate = endDatePicker.date

        NotificationCenter.default.post(name: .newEventCreated, object: nil, userInfo: [
            "title": title,
            "description": descriptionTextField.text ?? "",
            "startDate": startDate,
            "endDate": endDate
        ])
        dismiss(animated: true)
    }
}

// MARK: - UIPickerViewDataSource
extension WishEventCreationView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wishes.count
    }
}

// MARK: - UIPickerViewDelegate
extension WishEventCreationView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wishes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        titleTextField.text = wishes[row]
    }
}
