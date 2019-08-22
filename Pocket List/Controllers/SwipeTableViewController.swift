//
//  SwipeTableViewController.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/21/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
    }
    
    
    
    // TableView Datasource Methods
    
    // default cell for all tableviews that inherit it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create new cell from prototype cell in storyboard called Cell and
        // it gets created as a swipe table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // set cell's delegate as this current, SwipeTableViewController
        cell.delegate = self 
        
        return cell
    }
        
        
    // what should happen when user swipes on cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // swipe orientation from the right
        guard orientation == .right else { return nil }
        
        // when cell gets swiped, trigger SwipeAction closure
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)

        }
        // show image when user swipes the cell
        deleteAction.image = UIImage(named: "delete-icon")
        
        // return the delete action as user response on the cell
        return [deleteAction]
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
        // Update data model
        
    }


}
