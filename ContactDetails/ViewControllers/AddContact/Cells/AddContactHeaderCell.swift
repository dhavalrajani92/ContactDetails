//
//  AddContactHeaderCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

final class AddContactHeaderCell: UITableViewCell {
  static let identifier = "AddContactHeaderCell"
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.contentView.backgroundColor = UIColor(red: 0.70, green: 0.95, blue: 0.89, alpha: 1.00)
  }
}
