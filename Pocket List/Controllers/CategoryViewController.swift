//
//  CategoryViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/19/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    
    // MARK: - TableView Datasource Methods
    
    // display all categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // creates reusable cell and adds to the table at the index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }

    
    
    // MARK: - TableView Delegate Methods
    // what should happend when user clicks on one of the cells in the category table
    
    // triggers when user selects a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // target segue
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // gets triggered right before segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // store reference to destination of viewController
        let destinationVC = segue.destination as! TodoListViewController
        
        // get category that corresponds to selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    // MARK: - Data Manipulation Methods
    // set up data maniupulation methods, save and load data
    
    func saveCategories() {
        
        // try and commit context to persistent container
        do {
            try context.save()
        } catch {
            print("\nError saving category: \(error)\n")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        // read data from context
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("\nError loading categories: \(error)\n")
        }
        
        tableView.reloadData()
        
        
    }
    
    
    
    // MARK: - Add new categories
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    

}
