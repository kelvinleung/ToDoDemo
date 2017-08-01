//
//  TableViewController.swift
//  ToDoDemo
//
//  Created by Kelvin Leung on 01/08/2017.
//  Copyright © 2017 Kelvin Leung. All rights reserved.
//

import UIKit

let inputCellReuseId = "inputCell"
let todoCellReuseId = "todoCell"

class TableViewController: UITableViewController {
    
    enum Section: Int {
        case input = 0, todos, max
    }
    
    var todos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TODO - (0)"
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        ToDoStore.shared.getToDoItems { (data) in
            self.todos += data
            self.title = "TODO - (\(self.todos.count))"
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let inputIndexPath = IndexPath(row: 0, section: Section.input.rawValue)
        guard let inputCell = tableView.cellForRow(at: inputIndexPath) as? TableInputCell,
              let text = inputCell.textField.text else {
            return
        }
        todos.insert(text, at: 0)
        tableView.reloadData()
        inputCell.textField.text = ""
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .input: return 1
        case .todos: return todos.count
        case .max: fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseId, for: indexPath)
            guard let inputCell = cell as? TableInputCell else {
                return cell
            }
            inputCell.delegate = self
            return inputCell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: todoCellReuseId, for: indexPath)
            cell.textLabel?.text = todos[indexPath.row]
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.todos.rawValue {
            todos.remove(at: indexPath.row)
            self.title = "TODO - (\(todos.count))"
            tableView.reloadData()
        }
    }
}

extension TableViewController: TableInputCellDelegate {
    func inputChanged(cell: TableInputCell, text: String) {
        let isItemLengthEnough = text.count >= 3
        navigationItem.rightBarButtonItem?.isEnabled = isItemLengthEnough
    }
}
