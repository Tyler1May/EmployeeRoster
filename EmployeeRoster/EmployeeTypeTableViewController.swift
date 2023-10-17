//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Tyler May on 10/17/23.
//

import UIKit

protocol EmployeeTypeTableViewControllerDelegate: AnyObject {
    func didSelectEmployeeType(_:EmployeeTypeTableViewController,employeeType: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController {

    var employeeType: EmployeeType?
    
    weak var delegate: EmployeeTypeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  EmployeeType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeType", for: indexPath)
        
        let type = EmployeeType.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = type.description
        cell.contentConfiguration = content
    
        
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmployeeType = EmployeeType.allCases[indexPath.row]
        
        employeeType = selectedEmployeeType
        delegate?.didSelectEmployeeType(self, employeeType: employeeType!)
        tableView.reloadData()
    }
    
}
