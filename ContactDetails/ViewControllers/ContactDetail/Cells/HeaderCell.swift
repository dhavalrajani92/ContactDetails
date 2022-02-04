//
//  HeaderCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

final class HeaderCell: UITableViewCell {
  static var identifier = "HeaderCell"
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
  
  private lazy var actionsView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(red: 0.73, green: 0.94, blue: 0.88, alpha: 1.00)
    return view
  }()
  
  private lazy var messageLabel: UILabel = {
    let label  = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isUserInteractionEnabled = true
    label.text = "Message"
    return label
  }()
  
  private lazy var emailLabel: UILabel = {
    let label  = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isUserInteractionEnabled = true
    label.text = "Email"
    return label
  }()
  
  private lazy var callLabel: UILabel = {
    let label  = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isUserInteractionEnabled = true
    label.text = "Call"
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
    self.contentView.backgroundColor = UIColor(red: 0.73, green: 0.95, blue: 0.89, alpha: 1.00)
    
    self.contentView.addSubview(userImageView)
    self.contentView.addSubview(nameLabel)
    self.contentView.addSubview(actionsView)
    
    actionsView.addSubview(messageLabel)
    actionsView.addSubview(emailLabel)
    actionsView.addSubview(callLabel)
    
    NSLayoutConstraint.activate([
      userImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      userImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
      userImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -16),
      userImageView.heightAnchor.constraint(equalToConstant: 200),
      userImageView.widthAnchor.constraint(equalToConstant: 200),
      
      nameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      
      actionsView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
      actionsView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      actionsView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 16),
      actionsView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
      
      messageLabel.leadingAnchor.constraint(equalTo: actionsView.leadingAnchor, constant: 50),
      messageLabel.trailingAnchor.constraint(equalTo: emailLabel.leadingAnchor, constant: -50),
      messageLabel.topAnchor.constraint(equalTo: actionsView.topAnchor, constant: 10),
      messageLabel.bottomAnchor.constraint(equalTo: actionsView.bottomAnchor, constant: -10),
      
      emailLabel.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 50),
      emailLabel.trailingAnchor.constraint(equalTo: callLabel.leadingAnchor, constant: -50),
      emailLabel.topAnchor.constraint(equalTo: messageLabel.topAnchor),
      emailLabel.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor),
      
      callLabel.topAnchor.constraint(equalTo: messageLabel.topAnchor),
      callLabel.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor),
    ])
    
  }
  
  func render(image: URL, name: String, mobile: String?, email: String?) {
    nameLabel.text = name
    ImageDownloder.downloadImage(from: image) {[weak self] imageData, error in
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
