//
//  ContactListDetailCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

final class ContactDetailCell: UITableViewCell, FormBaseTableViewCell {
  
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
  
  private lazy var starIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "starIcon", in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = UIColor(red: 0.31, green: 0.89, blue: 0.75, alpha: 1.00)
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  private lazy var nameLabelTraillingAnchor = nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layoutSubviews()
    userImageView.layer.masksToBounds = true
    userImageView.layer.cornerRadius = userImageView.bounds.width / 2
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    starIcon.removeFromSuperview()
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
      
      nameLabelTraillingAnchor,
      nameLabel.topAnchor.constraint(equalTo: self.userImageView.topAnchor),
      nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
    ])
  }
  
  func render(image: String?, name: String, uploadedImage: Data?, isFavorite: Bool = false) {
    nameLabel.text = name
    
    if isFavorite == true {
      nameLabelTraillingAnchor.isActive = false
      self.contentView.addSubview(starIcon)
      
      NSLayoutConstraint.activate([
        starIcon.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        starIcon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        starIcon.widthAnchor.constraint(equalToConstant: 25),
        starIcon.heightAnchor.constraint(equalToConstant: 25)
      ])
    }
    
    
    if let uploadedImage = uploadedImage {
      self.userImageView.image = UIImage(data: uploadedImage)
    } else if let imageString = image, let url = URL(string: imageString) {
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
  
}
