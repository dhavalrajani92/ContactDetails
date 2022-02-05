//
//  AddContactHeaderCell.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import UIKit

protocol ImageUploadDelegate {
  func updateImage(image: UIImage)
}

final class AddContactHeaderCell: UITableViewCell, FormBaseTableViewCell {
  var parentController: UIViewController?
  var delegate: ImageUploadDelegate?
  private lazy var imagePicker: ImagePicker = {
    let imagePicker = ImagePicker()
    imagePicker.delegate = self
    return imagePicker
  }()
  
  private lazy var userImageView: UIImageView = {
    let circularImage = UIImageView()
    circularImage.translatesAutoresizingMaskIntoConstraints = false
    circularImage.isUserInteractionEnabled = true
    return circularImage
  }()
  
  private lazy var cameraIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let cameraIconImage =  UIImage(named: "cameraIcon", in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    imageView.image = cameraIconImage
    imageView.tintColor = UIColor(red: 0.31, green: 0.89, blue: 0.75, alpha: 1.00)
    
    return imageView
  }()
 
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
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.contentView.addSubview(userImageView)
    self.contentView.addSubview(cameraIcon)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    userImageView.addGestureRecognizer(tapGestureRecognizer)
    
    
    userImageView.image = UIImage(named: "defaultAvatar", in: nil, compatibleWith: nil)
    
    NSLayoutConstraint.activate([
      userImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      userImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
      userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      userImageView.heightAnchor.constraint(equalToConstant: 100),
      userImageView.widthAnchor.constraint(equalToConstant: 100),
      
      cameraIcon.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 0),
      cameraIcon.widthAnchor.constraint(equalToConstant: 25),
      cameraIcon.heightAnchor.constraint(equalToConstant: 25),
      cameraIcon.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 0)
    ])
    
  }
  
  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    imagePicker.photoGalleryAsscessRequest()
  }
}

extension AddContactHeaderCell: ImagePickerDelegate {
  func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool, to sourceType: UIImagePickerController.SourceType) {
    guard grantedAccess, let parentController = parentController else { return }
    imagePicker.present(parent: parentController, sourceType: sourceType)
  }
  
  func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
    userImageView.image = image
    delegate?.updateImage(image: image)
    imagePicker.dismiss()
  }
  
  func cancelButtonDidClick(on imageView: ImagePicker) {
    imagePicker.dismiss()
  }
  
  
}
