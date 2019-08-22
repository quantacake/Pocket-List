//
//  ViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/16/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // is nil until set in CategoryViewController
    var selectedCategory : Category? {
        // triggers as soon as selectedCategory contains a value (not nil)
        didSet {
            loadItems()
            
            tableView.separatorStyle = .none
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // after viewDidLoad runs, viewWillAppear will run next.
    // this protects from potential nil values in viewDidLoad since some processes
    // haven't ran yet and may contain nil values
    override func viewWillAppear(_ animated: Bool) {
        
        
        // set title if have selected category
        title = selectedCategory?.name
        
        // dynamically change navigation bar color
        guard let colorHex = selectedCategory?.cellColor else {  fatalError() }// if color is not nil
        
        updateNavBar(withHexCode: colorHex)
        
    
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    // MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        // nav controller is still nil on viewDidLoad
        // if nav controller does not yet exist, return error.
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        // change buttons to contrast color of nav bar
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        searchBar.barTintColor = navBarColor
        
        // change color of title
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        
    }
    
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of items in todoItems, if nil, return 1
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            // fill the new resuable cell with title, accessory type etc.
            cell.textLabel?.text = item.title
            
            // dynamically change cell and text color
            // if UIColor is not nil?,then try to darken it.
            if let color = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                // determines whether while or black text is the optimal choice
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
//            print("Version 1: \(CGFloat(indexPath.row / todoItems!.count))")
//            print("Version 2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
//
//            cell.backgroundColor =
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
    
    
    override func updateModel(at indexPath: IndexPath) {
        
        // use index path to delete data
        // this is the indexPath that gets passed in as the super class' method updateModel
        // at indexPath.
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item: \(error)")
            }

        }
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
