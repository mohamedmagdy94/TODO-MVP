//
//  UserTodoListProtocol.swift
//  TodoVIPER
//
//  Created by Mohamed El-Taweel on 9/9/20.
//  Copyright © 2020 Learning. All rights reserved.
//

import Foundation

protocol UserTodoListPresenterProtocol{
    var todoViewModels: [UserTodoCellViewModel]{get}
    func getTodoList()
}

protocol UserTodoListViewProtocol: class{
    func showTodoList()
    func showLoading()
    func hideLoading()
    func showError(with message: String)
}

