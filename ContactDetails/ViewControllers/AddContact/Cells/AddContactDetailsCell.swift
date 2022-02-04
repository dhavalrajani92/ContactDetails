//
//  AddContactDetailsCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

final class AddContactDetailsCell: UITableViewCell {
  static let identifier = "AddContactDetailsCell"
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    return label
  }()
  
  private lazy var valueTextField: TextFieldWithPadding = {
    let textField = TextFieldWithPadding()
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
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
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      titleLabel.widthAnchor.constraint(equalToConstant: 100),
      
      valueTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
      valueTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      valueTextField.topAnchor.constraint(equalTo: titleLabel.topAnchor),
      valueTextField.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      valueTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
    ])
  }
  
  func render(title: String) {
    titleLabel.text = title
  }
}

class TextFieldWithPadding: UITextField {
  var textPadding = UIEdgeInsets(
    top: 10,
    left: 10,
    bottom: 10,
    right: 10
  )
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: textPadding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.inset(by: textPadding)
  }
}
