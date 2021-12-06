//
//  MainViewController.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import UIKit

class MainViewController: UIViewController {

    let viewModel = MainViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: Outlet
    @IBOutlet weak var userListButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: viewModel)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userListButton.layer.cornerRadius = self.userListButton.frame.height / 2
        self.userListButton.layer.borderColor = UIColor.black.cgColor
        self.userListButton.layer.borderWidth = 1.5
    }
    
    // MARK: Outlet functions
    @IBAction func userListButtonAction(_ sender: Any) {
        viewModel.fetchUsers()
    }
    
    // MARK: Functions
    func goToUserListPage(users: [User]) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userListPageVC = storyboard.instantiateViewController(withIdentifier: "UserListPageVC") as! UserListPageViewController
            userListPageVC.viewModel.setUsers(users: users)
            let navigationController = UINavigationController(rootViewController: userListPageVC)
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalTransitionStyle = .flipHorizontal
            self.present(navigationController, animated: true, completion: nil)
        }

    }
    
}

// MARK: Extensions
extension MainViewController {
    func bind(to viewModel: MainViewModel) {
        viewModel.$fetchUserState.sink { state in
            switch state {
            case .finished:
                self.goToUserListPage(users: viewModel.users)
            case .failed:
                PopUpViewController.showPopup(parentVC: self, titleText: "Error Occured", descriptionText: "Unable to retrieve data from server.\n Tap OK to load data from local", okButtonHandler: {
                    self.viewModel.users = self.viewModel.dataManager.fetchUserList()
                    self.goToUserListPage(users: viewModel.users)
                }, cancelButtonHandler: nil)

            case .waiting:
                break
            }
            
        }.store(in: &subscriptions)
    }
}
