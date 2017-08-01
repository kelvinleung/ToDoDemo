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
    
    struct State {
        let todos: [String]
        let text: String
    }
    
    // 统一更新 UI
    var state = State(todos: [], text: "") {
        didSet {
            // 新旧值对比，有变化时更新 UI
            if oldValue.todos != state.todos {
                tableView.reloadData()
                title = "TODO - (\(state.todos.count))"
            }
            if oldValue.text != state.text {
                let isItemLengthEnough = state.text.count >= 3
                navigationItem.rightBarButtonItem?.isEnabled = isItemLengthEnough
                
                let inputIndexPath = IndexPath(row: 0, section: Section.input.rawValue)
                let inputCell = tableView.cellForRow(at: inputIndexPath) as? TableInputCell
                inputCell?.textField.text = state.text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TODO - (0)"
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        ToDoStore.shared.getToDoItems { (data) in
            self.state = State(todos: self.state.todos + data, text: self.state.text)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        state = State(todos: [state.text] + state.todos, text: "")
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
        // 从 state 中读取
        case .todos: return state.todos.count
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
            // 从 state 中读取
            cell.textLabel?.text = state.todos[indexPath.row]
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.todos.rawValue else {
            return
        }
        // 从数组中移除 indexPath.row 对应的数据
        let newTodos = Array(state.todos[..<indexPath.row] + state.todos[(indexPath.row + 1)...])
        state = State(todos: newTodos, text: state.text)
    }
}

extension TableViewController: TableInputCellDelegate {
    func inputChanged(cell: TableInputCell, text: String) {
        // 重新赋值
        state = State(todos: state.todos, text: text)
    }
}
