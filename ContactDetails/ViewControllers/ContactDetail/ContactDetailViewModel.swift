//
//  ContactDetailViewModel.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import CoreData

final class ContactDetailViewModel {
  var contact: Contacts
  
  init(contact: Contacts) {
    self.contact = contact
  }
}

extension ContactDetailViewModel {
  var userImageUrl: URL? {
    guard let urlString = contact.avatarUrl, let url = URL(string: urlString) else { return nil }
    return url
  }
  
  var userUploadedImage: Data? {
    return contact.userUploadedImage
  }
  
  var name: String {
    return (contact.firstName ?? "") + " " + (contact.lastName ?? "")
  }
  
  var mobile: String {
    return contact.mobileNumber ?? ""
  }
  
  var email: String {
    return contact.email ?? ""
  }
  
  var isFavroite: Bool {
    return contact.isFavourite ?? false
  }
}
