//
//  ContactListViewModel.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 03/02/22.
//

final class ContactListViewModel: Fetching {
  var fetchState: FetchState = .none {
    didSet {
      notifyObserver()
    }
  }
  
  var fetchCallback: ((FetchState) -> Void)?
  
  private let contactDetailsOperation: NetworkOperation
  
  var contactListData: [[String: Any]]? = nil
  
  init(contactDetailsOperation: NetworkOperation) {
    self.contactDetailsOperation = contactDetailsOperation
  }
}

extension ContactListViewModel {
  func fetchData() {
    fetchState = .inProgress
    contactDetailsOperation.execute(completionHandler: { result in
      switch result {
      case .success(let data):
        self.contactListData = data
        self.fetchState = .success
      case .failure(let error):
        guard let error = error as? Failure else {
          return
        }
        self.fetchState = .failure(error.message)
      case .none:
        break
      }
    })
  }
}


