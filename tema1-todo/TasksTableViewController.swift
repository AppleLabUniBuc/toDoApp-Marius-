//
//  TasksTableViewController.swift
//  tema1-todo
//
//  Created by Marius Ilie on 31/03/17.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    var currentSection: Int = -1
    var delegate: SectionsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = self.delegate?.categories[currentSection] {
            self.navigationItem.title = "\(category["name"]!)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.delegate?.categories[currentSection]["tasks"] as? [[String: String]])?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        if let category = self.delegate?.categories[currentSection] {
            if let tasks = category["tasks"] as? [[String: String]] {
                cell.textLabel?.text = tasks[indexPath.row]["name"]!
                cell.detailTextLabel?.text = tasks[indexPath.row]["description"]!
            }
        }
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationvc = segue.destination as? SingleTaskViewController {
            destinationvc.delegate = self
            
            if let cell = sender as? UITableViewCell {
                destinationvc._currentTask = (self.tableView.indexPath(for: cell)?.row)!
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var tasks = self.delegate?.categories[currentSection]["tasks"] as? [[String: String]]
            tasks?.remove(at: indexPath.row)
            self.delegate?.categories[currentSection]["tasks"] = tasks
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .bottom)
            self.tableView.endUpdates()
        }
    }
}
