//
//  TodoUserListProtocol.swift
//  VIPER
//
//  Created by Mohamed El-Taweel on 9/8/20.
//  Copyright © 2020 Learning. All rights reserved.
//

import Foundation

protocol TodoUserListProtocolPresenterProtocol{
    var usersViewModels: [TodoUserTableCellViewModel]{get}
    func getUserList()
    func getUserDetails(with index: Int)
    
}

protocol TodoUserListProtocolViewProtocol: class{
    func showUserList()
    func showLoading()
    func hideLoading()
    func showUserDetails(with userId: Int)
    func showError(with message: String)
}

