//
//  TodoUserListViewController.swift
//  VIPER
//
//  Created by Mohamed El-Taweel on 9/1/20.
//  Copyright (c) 2020 Learning. All rights reserved.


import UIKit
import KRProgressHUD


class TodoUserListViewController: UIViewController
{
    @IBOutlet weak var todoUserTableView: UITableView!
    
    var presenter: TodoUserListProtocolPresenterProtocol?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        presenter = TodoUserListPresenter(view: self)
        presenter?.getUserList()
    }
    
}

extension TodoUserListViewController: TodoUserListProtocolViewProtocol{
    
    func hideLoading() {
        KRProgressHUD.dismiss()
    }
    
    
    func showUserList() {
        todoUserTableView.reloadData()
    }
    
    func showLoading() {
        KRProgressHUD.show()
    }
    
    func showUserDetails(with userId: Int) {
        let destinationViewController = UIViewController.create(storyboardName: "UserTodoList", viewControllerID: "UserTodoListViewController") as! UserTodoListViewController
        destinationViewController.userId = userId
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func showError(with message: String) {
        KRProgressHUD.dismiss()
    }
    
}

extension TodoUserListViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.getUserDetails(with: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.usersViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = presenter?.usersViewModels[indexPath.row] else{ return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoUserTableViewCell.IDENTIFIER, for: indexPath) as! TodoUserTableViewCell
        cell.config(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
}




