//
//  Model.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 03/02/22.
//

import CoreData

extension Contacts {
  func update(with jsonDictionary: [String: Any]) throws {
      guard let firstName = jsonDictionary["firstName"] as? String,
            let lastName = jsonDictionary["lastName"] as? String,
            let avatarUrl = jsonDictionary["avatarUrl"] as? String,
            let isFavourite = jsonDictionary["isFavourite"] as? Bool,
            let mobileNumber = jsonDictionary["mobileNumber"] as? String,
            let email = jsonDictionary["email"] as? String,
            let id = jsonDictionary["id"] as? String else {
        throw NSError(domain: "", code: 100, userInfo: nil)
      }
      
    self.firstName = firstName
    self.lastName = lastName
    self.avatarUrl = avatarUrl
    self.isFavourite = isFavourite
    self.mobileNumber = mobileNumber
    self.email = email
    self.id = id
    self.firstNameInitial = firstName.stringGroupByFirstInitial
  }
}


extension String {
  subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
  var stringGroupByFirstInitial: String {
    if ((self.count == 0) || self.count == 1) {
      return self
    }
    
    return String(self[0])
  }
}
