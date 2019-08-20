//
//  ViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/16/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "item 1"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "item 2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "item 3"
        itemArray.append(newItem3)

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        cell.textLabel?.text = itemArray[indexPath.row].title // current row of current index path
        
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // add or remove checkmark accessory to cell when on tap
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK - Add New Items
    @IBAction func addButtonTapped(_ sender: Any) {
        
        var textField = UITextField() 

        let alert = UIAlertController(title: "Add New Pocket Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on the UIAlert

//            guard let text: String = textField.text else {
//                print("No item added")
//                return
//            }

            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            // save user data into key TodoListArray in users plist file. 
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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

