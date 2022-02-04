//
//  ContactListDetailCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

final class ContactDetailCell: UITableViewCell {
  
  static let identifier = "ContactDetailCell"
  
  private lazy var userImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var nameLabel: UILabel = {
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
    super.init(coder: coder)
  }
  
  private func setupView() {
    self.contentView.addSubview(userImageView)
    self.contentView.addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
      userImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
      userImageView.trailingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor, constant: -16),
      userImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
      userImageView.heightAnchor.constraint(equalToConstant: 40),
      userImageView.widthAnchor.constraint(equalToConstant: 40),
      userImageView.bottomAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
      
      nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      nameLabel.topAnchor.constraint(equalTo: self.userImageView.topAnchor),
      nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
    ])
  }
  
  func render(image: String, name: String) {
    nameLabel.text = name
    
    guard let url = URL(string: image) else {
      return
    }
    
    ImageDownloder.downloadImage(from: url) {[weak self] imageData, error in
      if let imageData = imageData {
        DispatchQueue.main.async {
          self?.userImageView.image = UIImage(data: imageData)
        }
      } else {
        print((error as? Failure)?.message)
      }
    }
    
  }
  
}
