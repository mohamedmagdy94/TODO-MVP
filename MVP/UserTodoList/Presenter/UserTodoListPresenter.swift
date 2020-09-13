//
//  UserTodoListPresenter.swift
//  MVP
//
//  Created by Mohamed El-Taweel on 9/13/20.
//  Copyright © 2020 Learning. All rights reserved.
//

import Foundation
import Moya

class UserTodoListPresenter: UserTodoListPresenterProtocol {
    
    
    var userId : Int
    weak var view: UserTodoListViewProtocol?
    var todoViewModels: [UserTodoCellViewModel]
    var networkRouter: MoyaProvider<UserTodoNetworkRouter>
    var response: UserTodoListResponse?
    
    
    init(userId: Int,view: UserTodoListViewProtocol) {
        self.userId = userId
        self.view = view
        self.todoViewModels = []
        self.networkRouter = MoyaProvider<UserTodoNetworkRouter>(plugins: [NetworkLoggerPlugin()])
    }
    
    func getTodoList() {
        view?.showLoading()
        let requestBody = UserTodoListRequest(userId: "\(self.userId)")
        networkRouter
            .request(.UserTodoList(request: requestBody)) {[weak self] (result) in
                guard let weakSelf = self else{ return }
                switch result{
                case .success(let moyaResponse):
                    let data = moyaResponse.data
                    let codableTransformer = CodableTransformer()
                    guard let responseModel = codableTransformer.decodeObject(from: data, to: UserTodoListResponse.self) else{
                        weakSelf.view?.showError(with: UserTodoListError.ServerError.localizedDescription)
                        return
                    }
                    weakSelf.todoViewModels = responseModel.map{ UserTodoCellViewModel(title: $0.title, body: $0.body) }
                    weakSelf.view?.showTodoList()
                    weakSelf.view?.hideLoading()
                case .failure:
                    weakSelf.view?.showError(with: UserTodoListError.ServerError.localizedDescription)
                    break
                    
                }
        }
    }
    
    
    
}
