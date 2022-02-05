//
//  ViewController.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 02/02/22.
//

import UIKit
import CoreData
import MBProgressHUD

protocol ContactListDelegate {
  func didAction(_ action: ContactListActions)
}

enum ContactListActions {
  case navigateToDetail(contact: Contacts)
  case navigateToAddContact
}

class ContactListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var persistentContainer: NSPersistentContainer?
  var viewModel: ContactListViewModel?
  var delegate: ContactListDelegate?
  
  private var fetchedContacts: [Contacts] = []
  
  private lazy var fetchedResultsController: NSFetchedResultsController<Contacts> = {
    let fetchRequest = NSFetchRequest<Contacts>(entityName: "Contacts")
    let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let fetchedResultsController = NSFetchedResultsController<Contacts>(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer!.viewContext, sectionNameKeyPath: "firstNameInitial", cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.navigationBar.isHidden = false
    self.navigationItem.title = "Contacts"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    registerNibs()
    viewModel?.fetchCallback = {[weak self] fetchState in
      switch fetchState {
      case .inProgress:
        self?.showSpinner("Loading")
      case .success:
        DispatchQueue.main.async {
          self?.syncContactsToCoreData(results: self?.viewModel?.contactListData)
          self?.performFetch()
          self?.hideSpinner() 
          self?.tableView.reloadData()
        }
      case .failure(let error):
        print(error)
        DispatchQueue.main.async {
          self?.hideSpinner()
        }
      default:
        break
      }
    }
    
    performFetch()
    
    self.fetchedContacts = fetchedResultsController.fetchedObjects!
    if fetchedContacts.isEmpty {
      viewModel?.fetchData()
    }
  }
  
  @objc func addContact() {
    delegate?.didAction(.navigateToAddContact)
  }
  
  private func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func registerNibs() {
    tableView.register(ContactDetailCell.self, forCellReuseIdentifier: ContactDetailCell.identifier)
  }
  
  private func performFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  private func syncContactsToCoreData(results: [[String: Any]]?) {
    guard let results = results, let persistentContainer = self.persistentContainer else { return }
    let viewContext = persistentContainer.viewContext
    
    for result in results {
      guard let contact = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: viewContext) as? Contacts else {
        print("Error: failed to create object")
        return
      }
      do {
        try contact.update(with: result)
      } catch {
        print("Error: \(error)\nobject will be deleted")
        viewContext.delete(contact)
      }
      
      if viewContext.hasChanges {
        do {
          try viewContext.save()
        } catch {
          print("Error: \(error)\nnot able to save to coredata")
        }
        viewContext.reset()
      }
    }
  }
  
  private func showSpinner(_ message: String) {
    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.label.text = message
    hud.isUserInteractionEnabled = false
  }
  
  private func hideSpinner() {
    MBProgressHUD.hide(for: self.view, animated: true)
  }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    if let sections = fetchedResultsController.sections {
      return sections.count
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sectionInfo = fetchedResultsController.sections?[section] {
      return sectionInfo.numberOfObjects
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailCell.identifier) as? ContactDetailCell else { return UITableViewCell() }
    let rowData = fetchedResultsController.object(at: indexPath)
    cell.render(image: rowData.avatarUrl, name: (rowData.firstName ?? "") + " " + (rowData.lastName ?? ""), uploadedImage: rowData.userUploadedImage, isFavorite: rowData.isFavourite)
    return cell
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return fetchedResultsController.sectionIndexTitles
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionInfo = fetchedResultsController.sections?[section]
    return sectionInfo?.name
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rowData = fetchedResultsController.object(at: indexPath)
    delegate?.didAction(.navigateToDetail(contact: rowData))
  }
}

extension ContactListViewController: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.reloadData()
  }
}
