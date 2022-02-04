//
//  ContactDetailViewController.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import CoreData
import UIKit

class ContactDetailViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: ContactDetailViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    registerNibs()
  }
  
  private func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func registerNibs() {
    tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.identifier)
    tableView.register(UserDetailCell.self, forCellReuseIdentifier: UserDetailCell.identifier)
  }
  
}

extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel, let userImageUrl = viewModel.userImageUrl else { return UITableViewCell() }
    let nameLabel = viewModel.name
    
    switch indexPath.row {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell else { return UITableViewCell() }
      cell.render(image: userImageUrl, name: nameLabel, mobile: nil, email: nil)
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailCell.identifier, for: indexPath) as? UserDetailCell else { return UITableViewCell() }
      cell.render(title: "Mobile", value: viewModel.mobile)
      return cell
    case 2:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailCell.identifier, for: indexPath) as? UserDetailCell else { return UITableViewCell() }
      cell.render(title: "Email", value: viewModel.email)
      return cell
    default:
      return UITableViewCell()
    }
  }
}

