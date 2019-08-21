//
//  ViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/16/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // is nil until set in CategoryViewController
    var selectedCategory : Category? {
        // triggers as soon as selectedCategory contains a value (not nil)
        didSet {
            loadItems()
        }
    }
    
    // file path to documents folder
    // .first grabs first item


    // how to tap into persistent container in the DataModel file in DataModel directory
    // UIApplication.shared corresponds to the live application object
    // delegate of the app object. and downcast to AppDelegate object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let defaults = UserDefaults.standard
    // custom user defaults

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // stage items to be deleted. before being removed from itemArray
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        saveItems() // commit the items to database
        
        // add or remove checkmark accessory to cell when on tap
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // this can be used to update an attribute/property, crUd
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK - Add New Items
    @IBAction func addButtonTapped(_ sender: Any) {
        
        var textField = UITextField() 

        let alert = UIAlertController(title: "Add New Pocket Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on the UIAlert

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
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
    func saveItems() {
        
        // uses custom objects
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    // Item.fetchRequest() in permeter is the default value
    // use 'with' for external permeter and 'request' for internal use
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        // fetch resutls in the form of Item. datatype of output is Item
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("\nError fetching dat from context \(error)")
        }
        
        tableView.reloadData()
    }
    


}


// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    // query database
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // Query objects. add query to request
        // NSPredicate decides how data should be filtered.
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, and: predicate)
        
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // remove keyboard
            }
            
            
            
            
        }
    }
    
}
