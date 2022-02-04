//
//  ContactDetailsFlowViewModel.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 03/02/22.
//

final class ContactDetailsFlowViewModel {
  private let contactDetailsOperation: NetworkOperation
  init(contactDetailsOperation: NetworkOperation) {
    self.contactDetailsOperation = contactDetailsOperation
  }
}

extension ContactDetailsFlowViewModel {
  var contactListViewModel: ContactListViewModel {
    return ContactListViewModel(contactDetailsOperation: contactDetailsOperation)
  }
}

