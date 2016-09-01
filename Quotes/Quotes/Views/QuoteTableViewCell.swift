//
//  QuoteTableViewCell.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import SDWebImage

class QuoteTableViewCell: TableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var heardByLabel: UILabel!
    
    // MARK: Properties
    var quote: Quote? {
        didSet {
            syncToQuote()
        }
    }
    
    var searchTerm: String? {
        didSet {
            updateWithSearchTerm()
        }
    }
    
    override class func CellIdentifier() -> String {
        return "QuoteCell"
    }
    
    override class func NibName() -> String {
        return "QuoteTableViewCell"
    }
    
    override func commonInit() {
        super.commonInit()
        
        // Allows the separator to stretch to full width
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        userImageButton.makeCircular()
        userImageButton.imageView?.contentMode = .ScaleAspectFill
    }
    
    private func syncToQuote() {
        quoteLabel.text = quote?.text
        usernameLabel.text = quote?.owner?.username
        
        SDWebImageManager.sharedManager().downloadImageWithURL(quote?.owner?.getUserAvatarURL(), options: [], progress: nil, completed: { (image, error, cacheType, didUseCache, imageURL) -> Void in
            if (image != nil && error == nil) {
                self.userImageButton.setImage(image, forState: .Normal)
            } else {
                self.userImageButton.setImage(UIImage(named: "default_avatar")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
            }
        })

    }
    
    private func updateWithSearchTerm() {
        
    }

    // MARK: Interface Actions
    
    @IBAction func UserImageTapped(sender: UIButton) {
        let controller = AppData.sharedInstance.navigationManager.presentControllerOfType(.Profile) as! ProfileViewController
        controller.user = quote?.owner
    }
    
}
