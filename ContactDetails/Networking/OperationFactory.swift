//
//  OperationFactory.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 03/02/22.
//

final class OperationFactory {
  static func getContactDetails() -> NetworkOperation {
    return NetworkOperation(path: "/contactbook/v1/getlist", parameters: nil)
  }
}
