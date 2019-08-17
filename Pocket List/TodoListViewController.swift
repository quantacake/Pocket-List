//
//  ViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/16/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row] // current row of current index path
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    // prints row when user selects a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        // add or remove checkmark accessory to cell when on tap
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK - Add New Items
    @IBAction func addButtonTapped(_ sender: Any) {
        
        var textField = UITextField() 

        let alert = UIAlertController(title: "Add New Pocket Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on the UIAlert

            guard let text: String = textField.text else {
                print("No item added")
                return
            }
            self.itemArray.append(text)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    


}

