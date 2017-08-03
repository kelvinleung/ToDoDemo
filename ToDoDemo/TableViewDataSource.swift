//
//  TableViewDataSource.swift
//  ToDoDemo
//
//  Created by Kelvin Leung on 03/08/2017.
//  Copyright © 2017 Kelvin Leung. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    enum Section: Int {
        case input = 0, todos, max
    }
    
    var todos: [String]
    var owner: TableViewController?
    
    init(todos: [String], owner: TableViewController?) {
        self.todos = todos
        self.owner = owner
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .input: return 1
        case .todos: return todos.count
        case .max: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseId, for: indexPath)
            guard let inputCell = cell as? TableInputCell else {
                return cell
            }
            inputCell.delegate = owner
            return inputCell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: todoCellReuseId, for: indexPath)
            cell.textLabel?.text = todos[indexPath.row]
            return cell
        default:
            fatalError()
        }
    }
}
