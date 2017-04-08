//
//  SectionsTableViewController.swift
//  tema1-todo
//
//  Created by Marius Ilie on 31/03/17.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

class SectionsTableViewController: UITableViewController, AddTableViewCellDelegate {
    
    let userDefaultKey = "newh4"
    var categories = [[String: Any]]() {
        didSet {
            UserDefaults.standard.set(categories, forKey: userDefaultKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let existingUserDefaultTasks = UserDefaults.standard.object(forKey: userDefaultKey) as? [[String: Any]] {
            categories = existingUserDefaultTasks
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseIdentifier = "categoryCell"
        if indexPath.row == categories.count
        {
            reuseIdentifier = "addCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if indexPath.row == categories.count
        {
            let addCell = cell as? AddTableViewCell
            addCell?.delegate = self
        } else {
            cell.textLabel?.text = "\(categories[indexPath.row]["name"]!)"
            
            let arrayOfTasks = categories[indexPath.row]["tasks"] as? [[String: String]]
            cell.detailTextLabel?.text = "\(arrayOfTasks?.count ?? 0)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == categories.count {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.categories.remove(at: indexPath.row)
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .bottom)
            self.tableView.endUpdates()
        }
    }
    
    func addButtonWasTapped(withValue value: String?) {
        if value != "" {
            let newElement: [String: Any] = [
                "name": value!,
                "tasks": [[String: String]]()
            ]
            
            self.categories.append(newElement)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: categories.count - 1, section: 0)], with: .bottom)
            self.tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationvc = segue.destination as? TasksTableViewController {
            destinationvc.delegate = self
            
            if let cell = sender as? UITableViewCell {
                destinationvc.currentSection = (self.tableView.indexPath(for: cell)?.row)!
            }
        }
    }
}

