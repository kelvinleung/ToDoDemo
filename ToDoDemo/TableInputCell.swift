//
//  TableInputCell.swift
//  ToDoDemo
//
//  Created by Kelvin Leung on 01/08/2017.
//  Copyright © 2017 Kelvin Leung. All rights reserved.
//

import UIKit

protocol TableInputCellDelegate: class {
    func inputChanged(cell: TableInputCell, text: String)
}

class TableInputCell: UITableViewCell {
    
    weak var delegate: TableInputCellDelegate?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        delegate?.inputChanged(cell: self, text: sender.text ?? "")
    }
}
