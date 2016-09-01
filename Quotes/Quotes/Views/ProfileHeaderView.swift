//
//  ProfileHeaderView.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
//    func didSelectMenuItem(atIndex index: Int)
}

class ProfileHeaderView: View {

    // MARK: Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    
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
    }
    
    private func syncToUser() {
        // Update the UI here
        
    }
    
}
