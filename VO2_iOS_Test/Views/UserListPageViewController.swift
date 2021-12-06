//
//  UserListPageViewController.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import UIKit

class UserListPageViewController: UIViewController {
    
    let viewModel = UserListPageViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        bind(to: viewModel)
        self.setupUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: Functions
    private func setupUI() {
        self.title = "List of Users"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 255 / 255, green: 204 / 255, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
    }
    func goToUserEditPage(user: User) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userEditPageVC = storyboard.instantiateViewController(withIdentifier: "UserEditPageViewController") as! UserEditPageViewController
            userEditPageVC.viewModel.setUser(user: user)
            self.navigationController?.pushViewController(userEditPageVC, animated: true)
        }
    }
    private func subscribeInNotificationUpdate() {
        let updateUserNotificationName = Notification.Name("updateUserNotificationName")
        NotificationCenter.default
            .publisher(for: updateUserNotificationName)
            .sink { _ in
                self.viewModel.users = self.viewModel.dataManager.fetchUserList()
            }.store(in: &subscriptions)
    }
}

// MARK: Extensions
extension UserListPageViewController {
    func bind(to viewModel: UserListPageViewModel) {
        viewModel.$users.sink(receiveValue: { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).store(in: &subscriptions)
        viewModel.$deleteUserState.sink { state in
            switch state {
            case .failed(_, let userId):
                PopUpViewController.showPopup(parentVC: self, titleText: "Error Occured", descriptionText: "Unable to remove user from server.\n Tap OK to remove ir from local database", okButtonHandler: {
                    self.viewModel.dataManager.deleteUser(userId: userId)
                    self.viewModel.users = self.viewModel.dataManager.fetchUserList()
                }, cancelButtonHandler: nil)
                
            case .finished, .waiting:
                break
            }
        }.store(in: &subscriptions)
        self.subscribeInNotificationUpdate()
    }
}

extension UserListPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel.users[indexPath.row]
        self.goToUserEditPage(user: user)
    }
}
extension UserListPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.users.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PopUpViewController.showPopup(parentVC: self, titleText: "Remove User?", descriptionText: "Are you sure you want to delete this user?", okButtonHandler: {
                let user = self.viewModel.users[indexPath.row]
                self.viewModel.deleteUser(userId: user.id)
            }, cancelButtonHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.viewModel.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.setup(with: user)
        return cell
    }
    
}
