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
    
    struct State: StateType {
        var dataSource = TableViewDataSource(todos: [], owner: nil)
        var text: String = ""
    }
    
    enum Action: ActionType {
        case updateText(text: String)
        case addToDos(items: [String])
        case removeToDo(index: Int)
        case loadToDos
    }
    
    enum Command: CommandType {
        case loadToDos(completion: ([String]) -> Void)
    }
    
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = {
        [weak self] (state: State, action: Action) in
        
        var state = state
        var command: Command? = nil
        
        switch action {
        case .updateText(let text):
            state.text = text
        case .addToDos(let items):
            state.dataSource = TableViewDataSource(todos: items + state.dataSource.todos, owner: state.dataSource.owner)
        case .removeToDo(let index):
            let oldToDos = state.dataSource.todos
            state.dataSource = TableViewDataSource(todos: Array(oldToDos[..<index] + oldToDos[(index + 1)...]), owner: state.dataSource.owner)
        case .loadToDos:
            command = Command.loadToDos { data in
                self?.store.dispatch(.addToDos(items: data))
            }
        }
        
        return (state, command)
    }
    
    var store: Store<State, Action, Command>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = TableViewDataSource(todos: [], owner: self)
        store = Store(reducer: reducer, initialState: State(dataSource: dataSource, text: ""))
        
        store.subscribe { [weak self] (state, previousState, command) in
            self?.stateDidChanged(state: state, previousState: previousState, command: command)
        }
        
        stateDidChanged(state: store.state, previousState: nil, command: nil)
        store.dispatch(.loadToDos)
    }
    
    func stateDidChanged(state: State, previousState: State?, command: Command?) {
        if let command = command {
            switch command {
            case .loadToDos(let handler):
                ToDoStore.shared.getToDoItems(completionHandler: handler)
            }
        }
        
        if previousState == nil || previousState!.dataSource.todos != state.dataSource.todos {
            let dataSource = state.dataSource
            tableView.dataSource = dataSource
            tableView.reloadData()
            title = "TODO - (\(dataSource.todos.count))"
        }
        
        if previousState == nil || previousState!.text != state.text {
            let isItemLengthEnough = state.text.count >= 3
            navigationItem.rightBarButtonItem?.isEnabled = isItemLengthEnough
            
            let indexPath = IndexPath(row: 0, section: TableViewDataSource.Section.input.rawValue)
            let inputCell = tableView.cellForRow(at: indexPath) as? TableInputCell
            inputCell?.textField.text = state.text
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        store.dispatch(.addToDos(items: [store.state.text]))
        store.dispatch(.updateText(text: ""))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == TableViewDataSource.Section.todos.rawValue else {
            return
        }
        store.dispatch(.removeToDo(index: indexPath.row))
    }
}

extension TableViewController: TableInputCellDelegate {
    func inputChanged(cell: TableInputCell, text: String) {
        store.dispatch(.updateText(text: text))
    }
}
