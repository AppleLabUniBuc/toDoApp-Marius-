//
//  AddTableViewCell.swift
//  tema1-todo
//
//  Created by Marius Ilie on 31/03/17.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

protocol AddTableViewCellDelegate {
    func addButtonWasTapped(withValue value: String?)
}

class AddTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: AddTableViewCellDelegate?
    
    @IBAction func didEndOnExit(_ sender: Any) {
        textField.resignFirstResponder()
        self.addButtonTap(nil)
    }
    
    @IBAction func addButtonTap(_ sender: UIButton?) {
        self.delegate?.addButtonWasTapped(withValue: textField.text)
        self.textField.text = ""
    }
}

