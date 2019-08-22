//
//  CategoryViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/19/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // Initialize new realm database
    let realm = try! Realm()
    
    // realm queries all results with Results collection objects
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        // remove lines between cells
        tableView.separatorStyle = .none
        
    }
    
    
    // MARK: - TableView Datasource Methods
    
    // display all categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if categories is not nil, return categories.count else return 1
        // return 1 for one row
        return categories?.count ?? 1
    }

    
    // creates reusable cell from super class and adds to the table at the index path
    // with the textLabel text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // taps into cell and triggers cellForRowAt indexPath method
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.cellColor) else { fatalError() }
            
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        return cell
    }

    
    
    // MARK: - TableView Delegate Methods
    // what should happend when user clicks on one of the cells in the category table
    
    // triggers when user selects a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // target segue goToItems that sends user to the TodoListViewController
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // gets triggered right before segue is performed. before didSelectRowAt method.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // store reference to destination of viewController
        let destinationVC = segue.destination as! TodoListViewController
        
        // get category that corresponds to selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            // set the selected category to the category that the user selectes
            // which then triggers the segue
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    // MARK: - Data Manipulation Methods
    // set up data maniupulation methods, save and load data
    
    // pass in all new categories
    func save(category: Category) {
        
        // try and commit context to persistent container/realm
        do {
            try realm.write {
                // add data to database
                realm.add(category)
            }
        } catch {
            print("\nError saving category: \(error)\n")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        // set categories to look inside our realm and fetch all objects that belong to the
        // Category datatype
        categories = realm.objects(Category.self)
        
        // reloads tableView numberOfRowsInSection method
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    
    
    // MARK: - Add new categories
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // when Add button is tapped
        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            let newCategory = Category()
            // add user input text field to the new category's name
            newCategory.name = textField.text!
            newCategory.cellColor = UIColor.randomFlat.hexValue()
            // save the new category to the real database
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
