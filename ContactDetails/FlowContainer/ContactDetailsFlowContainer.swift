//
//  ContactDetailsFlowContainer.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 03/02/22.
//

import CoreData
import UIKit

final class ContactDetailsFlowContainer {
  unowned var navController: UINavigationController
  private let persistentContainer: NSPersistentContainer
  
  private let flowViewModel: ContactDetailsFlowViewModel
  
  lazy var initialViewController: UIViewController? = {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    guard let initialVc = mainStoryboard.instantiateInitialViewController() as? ContactListViewController else { return nil }
    initialVc.persistentContainer = self.persistentContainer
    initialVc.viewModel = flowViewModel.contactListViewModel
    initialVc.delegate = self
    return initialVc
  }()
  
  init(flowViewModel: ContactDetailsFlowViewModel, navController: UINavigationController, persistentContainer: NSPersistentContainer) {
    self.navController = navController
    self.persistentContainer = persistentContainer
    self.flowViewModel = flowViewModel
    setupRootViewController()
  }
  
  private func setupRootViewController() {
    guard let vc = initialViewController else {
      return
    }
    self.navController.pushViewController(vc, animated: false)
  }
}

extension ContactDetailsFlowContainer: ContactListDelegate {
  private func navigateToDetail(contact: Contacts) {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    guard let vc = mainStoryboard.instantiateViewController(withIdentifier: "contact_detail") as? ContactDetailViewController else { return }
    let viewModel = ContactDetailViewModel(contact: contact)
    vc.viewModel = viewModel
    vc.persistentContainer = persistentContainer
    self.navController.pushViewController(vc, animated: true)
  }
  
  private func navigateToAddContact() {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    guard let vc = mainStoryboard.instantiateViewController(withIdentifier: "add_contact") as? AddContactViewController else { return }
    vc.persistentContainer = persistentContainer
    vc.delegate = self
    self.navController.pushViewController(vc, animated: true)
  }
  
  
  func didAction(_ action: ContactListActions) {
    switch action {
    case .navigateToDetail(let contact):
      navigateToDetail(contact: contact)
    case .navigateToAddContact:
      navigateToAddContact()
    }
  }
}

extension ContactDetailsFlowContainer: AddContactViewDelegate {
  private func navigateToBack() {
    self.navController.popViewController(animated: true)
  }
  
  
  func didAction(_ action: AddContactViewActions) {
    switch action {
    case .navigateToBack:
      navigateToBack()
    }
  }
}
