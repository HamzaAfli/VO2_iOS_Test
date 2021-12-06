//
//  UserCell.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with user: User) {
        self.userNameLabel.text = user.first_name + " " + user.last_name
        self.emailLabel.text = user.email
        if let url = URL(string: user.avatar), let imageView = self.avatarImageView {
        ImageHelper.loadAvatar(url: url, in: imageView)
        }
    }
   
}
