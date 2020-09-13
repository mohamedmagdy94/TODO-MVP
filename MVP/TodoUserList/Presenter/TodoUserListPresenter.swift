//
//  TodoUserListPresenter.swift
//  MVP
//
//  Created by Mohamed El-Taweel on 9/13/20.
//  Copyright © 2020 Learning. All rights reserved.
//

import Foundation
import Moya

class TodoUserListPresenter: TodoUserListProtocolPresenterProtocol {
    
    var usersViewModels: [TodoUserTableCellViewModel]
    weak var view: TodoUserListProtocolViewProtocol?
    var networkRouter: MoyaProvider<TodoUserListNetworkRouter>
    var response: UserListResponse?
    
    
    init(view: TodoUserListProtocolViewProtocol) {
        self.view = view
        self.usersViewModels = []
        self.networkRouter =  MoyaProvider<TodoUserListNetworkRouter>(plugins: [NetworkLoggerPlugin()])
    }
    
    func getUserList() {
        view?.showLoading()
        networkRouter
            .request(.TodoUserList) {[weak self] (result) in
                guard let weakSelf = self else{ return }
                switch result{
                case .success(let moyaResponse):
                    let data = moyaResponse.data
                    let codableTransformer = CodableTransformer()
                    guard let responseModel = codableTransformer.decodeObject(from: data, to: UserListResponse.self) else{
                        weakSelf.view?.showError(with: TodoUserListError.ServerError.localizedDescription)
                        return
                    }
                    weakSelf.response = responseModel
                    weakSelf.usersViewModels = responseModel.map{ TodoUserTableCellViewModel(name: $0.username) }
                    weakSelf.view?.showUserList()
                    weakSelf.view?.hideLoading()
                case .failure:
                    weakSelf.view?.showError(with: TodoUserListError.ServerError.localizedDescription)
                    break
                    
                }
        }
    }
    
    func getUserDetails(with index: Int) {
        guard let user = response?[index] else{ return }
        self.view?.showUserDetails(with: user.id)
    }
    
    
}
