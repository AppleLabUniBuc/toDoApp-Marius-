//
//  ViewController.swift
//  tema1-todo
//
//  Created by Marius Ilie on 31/03/17.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

class SingleTaskViewController: UIViewController {
    
    var _currentTask: Int = -1
    var delegate: TasksTableViewController?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    var currentTask: [String:String]? {
        get {
            if _currentTask > -1 {
                let currentSession = delegate?.currentSection
                var tasks = delegate?.delegate?.categories[currentSession!]["tasks"] as? [[String: String]]
                return tasks?[_currentTask]
            } else {
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        
        self.navigationItem.title = currentTask?["name"]
        self.textField.text = currentTask?["name"]
        self.textView.text = currentTask?["description"]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
        textView.becomeFirstResponder()
    }
    
    @IBAction func saveButtonTap(_ sender: UIBarButtonItem) {
        if textField.text != "" {
            var categories = self.delegate?.delegate?.categories
            let currentSession = self.delegate?.currentSection
            var tasks = categories?[currentSession!]["tasks"] as? [[String: String]]
            
            if var currentTask = self.currentTask {
                currentTask["name"] = textField.text!
                currentTask["description"] = textView.text!
                
                tasks?[_currentTask] = currentTask
            } else {
                let newElement: [String: String] = [
                    "name": textField.text!,
                    "description": textView.text!
                ]
                
                tasks?.append(newElement)
            }
            
            categories?[currentSession!]["tasks"] = tasks
            self.delegate?.delegate?.categories = categories!
            
            self.delegate?.tableView.reloadData()
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
