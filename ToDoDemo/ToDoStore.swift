//
//  ToDoStore.swift
//  ToDoDemo
//
//  Created by Kelvin Leung on 01/08/2017.
//  Copyright © 2017 Kelvin Leung. All rights reserved.
//

import Foundation

let dummy = [
    "But the milk",
    "Walk the dog",
    "Wash the car"
]

struct ToDoStore {
    static let shared = ToDoStore()
    func getToDoItems(completionHandler: (([String]) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler?(dummy)
        }
    }
}
