//
//  ProfileHeaderView.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func saidByPressed(headerView: ProfileHeaderView, button: UIButton)
    func heardByPressed(headerView: ProfileHeaderView, button: UIButton)
}

class ProfileHeaderView: View {

    // MARK: Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var saidByButton: UIButton!
    @IBOutlet weak var heardByButton: UIButton!
    @IBOutlet weak var optionsContainerView: UIView!
    
    // MARK: Properties
    weak var delegate: ProfileHeaderViewDelegate?
    var user: User? {
        didSet {
            syncToUser()
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.makeCircular()
        
        // Log Out Button Styling
        logOutButton.clipsToBounds = true
        logOutButton.layer.cornerRadius = 15.0
        logOutButton.layer.borderWidth = 1.0
        logOutButton.layer.borderColor = UIColor.redColor().CGColor
        
    }
    
    private func syncToUser() {
        // Update the UI here
        
        userImageView.sd_setImageWithURL(user?.getUserAvatarURL(), placeholderImage: UIImage(named: "default_avatar"))
        
        if user != AppData.sharedInstance.localSession?.localUser {
            optionsContainerView.hidden = true
        }
    }
    
    @IBAction func heardByPressed(sender: UIButton) {
        heardByButton.selected = true
        saidByButton.selected = false
        delegate?.heardByPressed(self, button: sender)
    }
    
    @IBAction func saidByPressed(sender: UIButton) {
        heardByButton.selected = false
        saidByButton.selected = true
        delegate?.saidByPressed(self, button: sender)
    }
    
    @IBAction func logOutPressed(sender: UIButton) {
        AppData.sharedInstance.logOut()
    }
}
