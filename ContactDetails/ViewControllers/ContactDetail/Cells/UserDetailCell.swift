//
//  UserDetailCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

final class UserDetailCell: UITableViewCell, FormBaseTableViewCell {
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    return label
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
    self.contentView.addSubview(valueLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: self.valueLabel.leadingAnchor, constant: -16),
      titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
      titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
      
      valueLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
      valueLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor)
    ])
  }
  
  func render(title: String, value: String) {
    titleLabel.text = title
    valueLabel.text = value
  }
}
