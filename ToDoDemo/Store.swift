//
//  Store.swift
//  ToDoDemo
//
//  Created by Kelvin Leung on 02/08/2017.
//  Copyright © 2017 Kelvin Leung. All rights reserved.
//

import Foundation

protocol StateType {}
protocol ActionType {}
protocol CommandType {}

class Store<S: StateType, A: ActionType, C: CommandType> {
    let reducer: (_ state: S, _ action: A) -> (S, C?)
    var subscriber: ((_ state: S, _ previousState: S, _ command: C?) -> Void)?
    var state: S
    
    init(reducer: @escaping (S, A) -> (S, C?), initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }
    
    func dispatch(_ action: A) {
        let previousState = state
        let (nextState, command) = reducer(previousState, action)
        state = nextState
        subscriber?(state, previousState, command)
    }
    
    func subscribe(_ handler: @escaping (S, S, C?) -> Void) {
        self.subscriber = handler
    }
    
    func unsubscribe() {
        self.subscriber = nil
    }
}
