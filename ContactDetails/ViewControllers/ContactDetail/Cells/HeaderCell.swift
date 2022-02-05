//
//  HeaderCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

protocol HeaderCellDelegate {
  func makeContactFavorite()
}

final class HeaderCell: UITableViewCell, FormBaseTableViewCell {
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
    label.textColor = .blue
    return label
  }()
  
  private lazy var emailLabel: UILabel = {
    let label  = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isUserInteractionEnabled = true
    label.text = "Email"
    label.textColor = .blue
    return label
  }()
  
  private lazy var callLabel: UILabel = {
    let label  = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isUserInteractionEnabled = true
    label.text = "Call"
    label.textColor = .blue
    return label
  }()
  
  private lazy var starIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private var email: String?
  private var mobile: String?
  
  var delegate: HeaderCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layoutSubviews()
    userImageView.layer.masksToBounds = true
    userImageView.layer.cornerRadius = userImageView.bounds.width / 2
    
    self.addLinearGradient(colors: [UIColor.white.cgColor, UIColor(red: 0.31, green: 0.89, blue: 0.75, alpha: 1.00).cgColor])
    self.bringSubviewToFront(contentView)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func setupView() {
    
    self.contentView.addSubview(userImageView)
    self.contentView.addSubview(starIcon)
    self.contentView.addSubview(nameLabel)
    self.contentView.addSubview(actionsView)
    
    actionsView.addSubview(messageLabel)
    actionsView.addSubview(emailLabel)
    actionsView.addSubview(callLabel)
    
    let tapGestureRecognizerMessage = UITapGestureRecognizer(target: self, action: #selector(openMessage(tapGestureRecognizer:)))
    messageLabel.addGestureRecognizer(tapGestureRecognizerMessage)
    
    let tapGestureRecognizerCall = UITapGestureRecognizer(target: self, action: #selector(openCall(tapGestureRecognizer:)))
    callLabel.addGestureRecognizer(tapGestureRecognizerCall)
    
    let tapGestureRecognizerEmail = UITapGestureRecognizer(target: self, action: #selector(openEmail(tapGestureRecognizer:)))
    emailLabel.addGestureRecognizer(tapGestureRecognizerEmail)
    
    let tapGestureRecognizerFavorite = UITapGestureRecognizer(target: self, action: #selector(makeFavorite(tapGestureRecognizer:)))
    starIcon.addGestureRecognizer(tapGestureRecognizerFavorite)
    
    NSLayoutConstraint.activate([
      
      starIcon.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      starIcon.widthAnchor.constraint(equalToConstant: 25),
      starIcon.heightAnchor.constraint(equalToConstant: 25),
      starIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
      
      userImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      userImageView.topAnchor.constraint(equalTo: self.starIcon.topAnchor, constant: 5),
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
  
  func render(image: URL?, userUploadedImage: Data?, name: String, mobile: String?, email: String?, isFavorite: Bool = false) {
    nameLabel.text = name
    self.email = email
    self.mobile = mobile
    if isFavorite == true {
      starIcon.image = UIImage(named: "starIcon", in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
      starIcon.tintColor = UIColor(red: 0.73, green: 0.95, blue: 0.89, alpha: 1.00)
    } else {
      starIcon.image = UIImage(named: "starIcon", in: nil, compatibleWith: nil)
    }
    
    if let userUploadedImage = userUploadedImage {
      userImageView.image = UIImage(data: userUploadedImage)
    } else if let image = image {
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
  
  @objc func openMessage(tapGestureRecognizer: UITapGestureRecognizer) {
    guard let mobile = self.mobile else { return }
    let sms: String = "sms:\(mobile)&body=Hello Abc How are You I am ios developer."
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    
  }
  
  @objc func openCall(tapGestureRecognizer: UITapGestureRecognizer) {
    if let number = self.mobile, let url = URL(string: "tel://\(number)") {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
  }
  
  @objc func openEmail(tapGestureRecognizer: UITapGestureRecognizer) {
    if let number = self.email, let url = URL(string: "mailto://\(number)") {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
  }

  @objc func makeFavorite(tapGestureRecognizer: UITapGestureRecognizer) {
    delegate?.makeContactFavorite()
  }
}
