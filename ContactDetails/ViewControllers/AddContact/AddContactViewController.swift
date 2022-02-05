//
//  AddContactViewController.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import CoreData
import UIKit

protocol AddContactViewDelegate {
  func didAction(_ action: AddContactViewActions)
}

enum AddContactViewActions {
  case navigateToBack
}

class AddContactViewController: UIViewController {
  
  var persistentContainer: NSPersistentContainer?
  var delegate: AddContactViewDelegate?
  
  @IBOutlet weak var tableView: UITableView!
  
  struct AddContactTableViewConfig {
    var cellType: AddContactCellType
    var title: String? = nil
    var field: ContactDetailsFormFields? = nil
  }

  enum AddContactCellType {
    case headerCell
    case detailCell
  }
  
  private let tableViewConfig = [
    AddContactTableViewConfig(cellType: .headerCell, field: .userImage),
    AddContactTableViewConfig(cellType: .detailCell, title: "First name", field: .firstName),
    AddContactTableViewConfig(cellType: .detailCell, title: "Last name", field: .lastName),
    AddContactTableViewConfig(cellType: .detailCell, title: "Mobile", field: .mobile),
    AddContactTableViewConfig(cellType: .detailCell, title: "Email", field: .email)
  ]
  
  private lazy var formInstance = ContactDetailForm(fields: tableViewConfig.map { $0.field ?? .unknown })
  private var formCells: [ContactDetailsFormFields : FormBaseTableViewCell] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNavigation))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveData))
  }
  
  private func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func registerNibs() {
    tableView.register(AddContactHeaderCell.self, forCellReuseIdentifier: AddContactHeaderCell.identifier)
    tableView.register(AddContactDetailsCell.self, forCellReuseIdentifier: AddContactDetailsCell.identifier)
  }
  
  @objc func saveData() {
    tableView.beginUpdates()
    if validateAllData() == true {
      saveDataToCoreData()
    }
    tableView.endUpdates()
  }
  
  @objc func cancelNavigation() {
    delegate?.didAction(.navigateToBack)
  }
  
  private func saveDataToCoreData() {
    guard let viewContext = persistentContainer?.viewContext else { return }
    let contact = Contacts(context: viewContext)
    contact.firstName = formInstance.data(for: .firstName) as? String ?? ""
    contact.lastName = formInstance.data(for: .lastName) as? String ?? ""
    contact.mobileNumber = formInstance.data(for: .mobile) as? String ?? ""
    contact.email = formInstance.data(for: .email) as? String ?? ""
    contact.firstNameInitial = (formInstance.data(for: .firstName) as? String)?.stringGroupByFirstInitial
    contact.isFavourite = false
    contact.userUploadedImage = formInstance.data(for: .userImage) as? Data
    do {
      try viewContext.save()
    } catch {
      print("Error: \(error)\nnot able to save to coredata")
    }
    delegate?.didAction(.navigateToBack)
  }
  
  private func validateAllData() -> Bool {
    var status = true
    formInstance.validate { result in
      switch result {
      case .success(let field):
        let cell = formCells[field]
        cell?.removeError()
      case .failure(let error):
        status = false
        guard let errorObj = error as? ValidationError else { break }
        let cell = formCells[errorObj.field]
        cell?.addError(errorMessage: errorObj.message)
        break
      }
    }
    return status
  }
}

extension AddContactViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewConfig.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let data = tableViewConfig[indexPath.row]
    let title = data.title
    switch data.cellType {
    case .headerCell:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: AddContactHeaderCell.identifier, for: indexPath) as? AddContactHeaderCell else { return  UITableViewCell() }
      cell.parentController = self
      cell.delegate = self
      return cell
    case .detailCell:
      guard let fieldType = data.field, let cell = tableView.dequeueReusableCell(withIdentifier: AddContactDetailsCell.identifier, for: indexPath) as? AddContactDetailsCell else { return  UITableViewCell() }
      cell.delegate = self
      cell.render(fieldType: fieldType, title: title ?? "")
      formCells[fieldType] = cell
      return cell
    }
  }
}

extension AddContactViewController: FormTextFieldTableViewCellDelegate {
  func formFieldDidChange(field: ContactDetailsFormFields, value: Any?) {
    formInstance.update(field: field, with: value)
  }
  
  func formFieldDidEndEditing(_ field: ContactDetailsFormFields, value: Any?) {
    formInstance.update(field: field, with: value)
  }
  
  func formFieldDidBeginEditing(_ textView: UIView) {
    
  }
}

extension AddContactViewController: ImageUploadDelegate {
  func updateImage(image: UIImage) {
    formInstance.update(field: .userImage, with:image.pngData())
  }
  
  
}
