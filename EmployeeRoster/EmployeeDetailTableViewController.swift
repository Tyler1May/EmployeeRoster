
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet var dobDatePicker: UIDatePicker!
    
    var employeeType: EmployeeType?
    
    var isEditingBirthday = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
    }
    
    func didSelectEmployeeType(_: EmployeeTypeTableViewController, employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.text = employeeType.description
        employeeTypeLabel.textColor = .black
        
        updateSaveButtonState()
    }
    
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && employeeType != nil
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, let employeeType = employeeType else { return }
        
        let selectedDate = dobDatePicker.date
        
        let employee = Employee(name: name, dateOfBirth: selectedDate, employeeType: employeeType)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
        
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 {
            return isEditingBirthday ? UITableView.automaticDimension : 0
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 1 {
            isEditingBirthday.toggle()
            dobLabel.textColor = .label
            
            if isEditingBirthday {
                dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
            }
        }
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dobLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder, sender: Any?) -> EmployeeTypeTableViewController? {
            let employeeTypeViewController = EmployeeTypeTableViewController(coder: coder)
            employeeTypeViewController?.delegate = self
            return employeeTypeViewController
    }
    
}




