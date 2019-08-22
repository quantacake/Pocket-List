//
//  ViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/16/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    // is nil until set in CategoryViewController
    var selectedCategory : Category? {
        // triggers as soon as selectedCategory contains a value (not nil)
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of items in todoItems, if nil, return 1
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            // fill the new resuable cell with title, accessory type etc.
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            // if numberOfRowsInSection = nil, add "No Items Added" into the 1 cell
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    // MARK - TableView Delegate Methods
    // when user selects a cell to stamp it, signifying it is complete
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                // update value in the database
                try realm.write {
//                    realm.delete(item) // delete on tap
                    // toggle done property to the opposite of what it is
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        // reload data and deselct cell
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK - Add New Items
    @IBAction func addButtonTapped(_ sender: Any) {
        
        var textField = UITextField() 

        let alert = UIAlertController(title: "Add New Pocket Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on the UIAlert
            // check if user inputs a title for the new item,
            if let currentCategory = self.selectedCategory {
                do {
                    // add new items to a category
                    try self.realm.write {
                        let newItem = Item()
                        newItem.dateCreated = Date()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("\nError saving new items: \(error)\n")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK - Model Manupulation Methods
    // commit context to permanent storage inside persistent container
    // must use try context.save()
//    func saveItems() {
//
//        // uses custom objects
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//
//    }
    
    // Item.fetchRequest() in permeter is the default value
    // use 'with' for external permeter and 'request' for internal use
    func loadItems() {
        
        // all items that belong to the current selected category, add to itemArray
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
}


// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    // query database
    // user click search updates the collection of todo item
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // filter based on user input text and sort by date created in ascending order
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        // reload filtered items
        tableView.reloadData()

    }


    // dismiss search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // remove keyboard
            }
        }
    }

}
