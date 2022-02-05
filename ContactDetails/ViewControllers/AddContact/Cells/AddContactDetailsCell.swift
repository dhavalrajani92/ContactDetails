//
//  AddContactDetailsCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

enum ContactDetailsFormFields: CaseIterable {
  case firstName
  case lastName
  case mobile
  case email
  case userImage
  case unknown
}

protocol FormTextFieldTableViewCellDelegate: AnyObject {
  func formFieldDidChange(field: ContactDetailsFormFields, value: Any?)
  func formFieldDidEndEditing(_ field: ContactDetailsFormFields, value: Any?)
  func formFieldDidBeginEditing(_ textView: UIView)
}

enum TextFieldStyle {
  case normal
  case error
}

protocol FormBaseTableViewCell: class {
  static var identifier: String { get }
  func addError(errorMessage: String)
  func removeError()
}

extension FormBaseTableViewCell {
  static var identifier: String {
    return String(describing: self)
  }
  
  func addError(errorMessage: String) {}
  func removeError() {}
}

final class AddContactDetailsCell: UITableViewCell, FormBaseTableViewCell {
  
  private lazy var errorLabelLeadingAnchor = errorLabel.leadingAnchor.constraint(equalTo: valueTextField.leadingAnchor)
  private lazy var errorLabelTopAnchor = errorLabel.topAnchor.constraint(equalTo: valueTextField.bottomAnchor, constant: 5)
  private lazy var errorLabelBottomAnchor = errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
  private lazy var valueFieldBottomAnchor = valueTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
  
  var viewStyle: TextFieldStyle = .normal {
    
    didSet {
      if viewStyle == .error {
        errorLabelLeadingAnchor.isActive = true
        errorLabelTopAnchor.isActive = true
        errorLabelBottomAnchor.isActive = true
        valueFieldBottomAnchor.isActive = false
      } else {
        errorLabelLeadingAnchor.isActive = false
        errorLabelTopAnchor.isActive = false
        errorLabelBottomAnchor.isActive = false
        valueFieldBottomAnchor.isActive = true
      }
      
    }
  }
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    return label
  }()
  
  private lazy var valueTextField: TextFieldWithPadding = {
    let textField = TextFieldWithPadding()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self
    textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    return textField
  }()
  
  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .red
    return label
  }()
  
  private var fieldType: ContactDetailsFormFields?
  
  weak var delegate: FormTextFieldTableViewCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.contentView.addSubview(titleLabel)
    self.contentView.addSubview(valueTextField)
    self.contentView.addSubview(errorLabel)
    
    valueFieldBottomAnchor.isActive = true
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      titleLabel.widthAnchor.constraint(equalToConstant: 100),
      
      valueTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
      valueTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      valueTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      valueTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
    ])
  }
  
  func render(fieldType: ContactDetailsFormFields, title: String) {
    self.fieldType = fieldType
    titleLabel.text = title
  }
  
  func addError(errorMessage: String) {
    errorLabel.isHidden = false
    errorLabel.text = errorMessage
    viewStyle = .error
  }
  
  func removeError() {
    errorLabel.isHidden = true
    viewStyle = .normal
  }
  
}

extension AddContactDetailsCell: UITextFieldDelegate {
  @objc
  func textFieldDidChange(_ textField: UITextField) {
    guard let fieldType = fieldType else {
      return
    }

    delegate?.formFieldDidChange(field: fieldType, value: textField.text)
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.formFieldDidBeginEditing(textField)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let fieldType = fieldType else {
      return
    }
    delegate?.formFieldDidEndEditing(fieldType, value: textField.text)
  }
}

