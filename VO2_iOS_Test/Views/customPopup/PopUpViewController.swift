//
//  PopUpViewController.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import UIKit

class PopUpViewController: UIViewController {
    
    var okHandler:(() -> Void)?
    var cancelHandler:(() -> Void)?
    var titleText: String = ""
    var descriptionText: String = ""
    
    // MARK: Outlets
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: Outlet functions
    @IBAction func okButtonAction(_ sender: Any) {
        self.okHandler?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.cancelHandler?()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Functions
    private func setupLabelsTexts(titleText: String, descriptionText: String) {
        self.titleLabel.text = titleText
        self.descriptionLabel.text = descriptionText
    }
    private func setupUI() {
        self.setupLabelsTexts(titleText: titleText, descriptionText: descriptionText)
        self.okButton.layer.cornerRadius = self.okButton.frame.height / 2
        
        self.cancelButton.layer.borderColor = UIColor(red: 255 / 255, green: 204 / 255, blue: 0, alpha: 1).cgColor
        self.cancelButton.layer.borderWidth = 2
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        dialogBoxView.layer.cornerRadius = 15
    }
    static func showPopup(parentVC: UIViewController, titleText: String, descriptionText: String, okButtonHandler:(  () -> Void)?, cancelButtonHandler:(() -> Void)?) {
        DispatchQueue.main.async {
            if let popupViewController = UIStoryboard(name: "CustomView", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
                popupViewController.titleText = titleText
                popupViewController.descriptionText = descriptionText
                popupViewController.modalPresentationStyle = .custom
                popupViewController.modalTransitionStyle = .crossDissolve
                popupViewController.okHandler = okButtonHandler
                popupViewController.cancelHandler = cancelButtonHandler
                parentVC.present(popupViewController, animated: true)
            }
        }
    }
    
}
