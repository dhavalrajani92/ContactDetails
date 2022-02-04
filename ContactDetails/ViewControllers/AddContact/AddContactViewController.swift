//
//  AddContactViewController.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import CoreData
import UIKit

struct AddContactTableViewConfig {
  var cellType: AddContactCellType
  var title: String?
}

enum AddContactCellType {
  case headerCell
  case detailCell
}


class AddContactViewController: UIViewController {
  
  var persistentContainer: NSPersistentContainer?
  
  @IBOutlet weak var tableView: UITableView!
  
  private let tableViewConfig = [
    AddContactTableViewConfig(cellType: .headerCell, title: nil),
    AddContactTableViewConfig(cellType: .detailCell, title: "First name"),
    AddContactTableViewConfig(cellType: .detailCell, title: "Last name"),
    AddContactTableViewConfig(cellType: .detailCell, title: "Mobile"),
    AddContactTableViewConfig(cellType: .detailCell, title: "Email")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
  }
  
  private func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func registerNibs() {
    tableView.register(AddContactHeaderCell.self, forCellReuseIdentifier: AddContactHeaderCell.identifier)
    tableView.register(AddContactDetailsCell.self, forCellReuseIdentifier: AddContactDetailsCell.identifier)
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
      return cell
    case .detailCell:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: AddContactDetailsCell.identifier, for: indexPath) as? AddContactDetailsCell else { return  UITableViewCell() }
      cell.render(title: title ?? "")
      return cell
    }
  }
  
  
}
