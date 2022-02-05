//
//  ContactDetailForm.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 05/02/22.
//

import Foundation
import UIKit

struct ValidationError: Error {
  var message: String
  var field: ContactDetailsFormFields
}

final class ContactDetailForm {
  private let fields: [ContactDetailsFormFields]
  private lazy var validators: [ContactDetailsFormFields : [Validator]] = [:]
  private lazy var validationMessages: [ContactDetailsFormFields : [String: String]] = [:]
  private lazy var formData: [ContactDetailsFormFields : Any] = [:]
  
  init(fields: [ContactDetailsFormFields]) {
    self.fields = fields
    
    
    let activeFields = fields
    
    for field in activeFields {
      
      switch field {
      case .firstName:
        validators[field] = [RequiredValidator()]
        validationMessages[field] = ["\(RequiredValidator.self)": "First name required"]
      case .lastName:
        validators[field] = [RequiredValidator()]
        validationMessages[field] = ["\(RequiredValidator.self)": "last name required"]
      case .mobile:
        validators[field] = [RequiredValidator(), RegexValidator(regexString: #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#)]
        var messages: [String: String] = [:]
        messages["\(RequiredValidator.self)"] = "mobile number required"
        messages["\(RegexValidator.self)"] = "mobile number not valid"
        validationMessages[field] = messages
      case .email:
        validators[field] = [RequiredValidator(), RegexValidator(regexString: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")]
        var messages: [String: String] = [:]
        messages["\(RequiredValidator.self)"] = "email required"
        messages["\(RegexValidator.self)"] = "email not valid"
        validationMessages[field] = messages
      case .unknown, .userImage:
        break
      }
    }
  }
  
  func update(field: ContactDetailsFormFields, with value: Any?) {
    formData[field] = value
  }
  
  func data(for field: ContactDetailsFormFields) -> Any? {
    return formData[field]
  }
  
  func validate(resultCallback: (Result<ContactDetailsFormFields, Error>)-> Void) {
    for (field, validators) in validators {
      for validator in validators {
        let status = validator.validate(input: formData[field])
        if status {
          resultCallback(.success(field))
        } else {
          let errorMessage = validationMessages[field]?["\(type(of: validator))"] ?? ""
          resultCallback(.failure(ValidationError(message: errorMessage, field: field)))
          break
        }
      }
    }
  }
  
  func validate(for field: ContactDetailsFormFields) -> Result<ContactDetailsFormFields, Error> {
    for validator in validators[field] ?? [] {
      let status = validator.validate(input: formData[field])
      if status == false {
        let errorMessage = validationMessages[field]?["\(type(of: validator))"] ?? ""
        return .failure(ValidationError(message: errorMessage, field: field))
      }
    }
    return .success(field)
  }
}

protocol Validator {
  func validate(input: Any?) -> Bool
}

struct RequiredValidator: Validator {
  func validate(input: Any?) -> Bool {
    guard input != nil else { return false }
    if let input = input as? String {
      return !input.isEmpty
    }
    return true
  }
}

struct RegexValidator: Validator {
  let regexString: String
  
  func validate(input: Any?) -> Bool {
    guard let input = input as? String else { return false }
    return input.range(of: regexString, options: .regularExpression) != nil
  }
}
