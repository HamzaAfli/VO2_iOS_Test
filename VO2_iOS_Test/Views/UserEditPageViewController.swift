//
//  UserEditPageViewController.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import UIKit

class UserEditPageViewController: UIViewController {
    
    let viewModel = UserEditPageViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: viewModel)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    // MARK: Functions
    private func setupUI() {
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2
        self.cancelButton.layer.borderColor = UIColor(red: 255 / 255, green: 204 / 255, blue: 0, alpha: 1).cgColor
        self.cancelButton.layer.borderWidth = 2
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2
    }
    private func postNotificationUpdate() {
        let updateUserNotificationName = Notification.Name("updateUserNotificationName")
        NotificationCenter.default.post(name: updateUserNotificationName, object: nil, userInfo: nil)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Outlet functions
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveAction(_ sender: Any) {
        if let user = self.viewModel.user {
            let newUser = User(id: user.id, email: self.emailTextField.text ?? user.email, first_name: self.firstNameTextField.text ?? user.first_name, last_name: self.lastNameTextField.text ?? user.last_name, avatar: user.avatar)
            viewModel.updateUser(user: newUser)
        }
    }
    
}

// MARK: Extensions
extension UserEditPageViewController {
    func bind(to viewModel: UserEditPageViewModel) {
        viewModel.$user.sink(receiveValue: { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.firstNameTextField.text = user.first_name
                    self.lastNameTextField.text = user.last_name
                    self.emailTextField.text = user.email
                    if let url = URL(string: user.avatar), let imageView = self.avatarImageView {
                        ImageHelper.loadAvatar(url: url, in: imageView)
                    }
                }
            }
        }).store(in: &subscriptions)
        
        viewModel.$updateUserState.sink { state in
            switch state {
            case .failed(_, let user):
                PopUpViewController.showPopup(parentVC: self, titleText: "Error Occured", descriptionText: "Unable to update user in server.\n Tap OK to update it locally", okButtonHandler: {
                    self.viewModel.dataManager.updateUser(user: user)
                    self.postNotificationUpdate()
                }, cancelButtonHandler: nil)
                
            case .finished:
                self.postNotificationUpdate()
            case .waiting:
                break
            }
            
        }.store(in: &subscriptions)
        
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
