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
    @IBOutlet weak var dateLabel: UILabel!
    
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
        
        dateLabel.text = quote?.rawCreateTimeString
        
        setupUsernameText()
        setupQuotationText()
        setupHeardByString()
                
        SDWebImageManager.sharedManager().downloadImageWithURL(quote?.owner?.getUserAvatarURL(), options: [], progress: nil, completed: { (image, error, cacheType, didUseCache, imageURL) -> Void in
            if (image != nil && error == nil) {
                self.userImageButton.setImage(image, forState: .Normal)
            } else {
                self.userImageButton.setImage(UIImage(named: "default_avatar")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
            }
        })
    }
    
    private func setupUsernameText() {
        usernameLabel.text = quote?.owner?.username
        usernameLabel.textColor = .blackColor()

        if let term = searchTerm?.lowercaseString {
            if quote?.owner?.username?.lowercaseString.rangeOfString(term) == nil {
                usernameLabel.textColor = .lightGrayColor()
            }
        }
    }
    
    private func setupQuotationText() {
        
        guard let quoteText = quote?.text else {
            return
        }
        
        quoteLabel.attributedText = NSAttributedString.AttributedStringWithQuotations(quoteText, attributes: nil)
    }
    
    private func setupHeardByString() {
        
        guard let heardBy = quote?.heardBy else {
            return
        }
        
        let titleFont = UIFont.systemFontOfSize(15.0)
        let titleColor = UIColor.lightGrayColor()
        let usernameFont = UIFont.boldSystemFontOfSize(15.0)
        let usernameColor = UIColor.blackColor()
        let usernameGrayColor = UIColor.lightGrayColor()

        // Setup attributed string
        let titleText = NSAttributedString(string: "Heard by: ",
                                           attributes: [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: titleColor])
        
        let finalText = NSMutableAttributedString(attributedString: titleText)
        
        for user in heardBy {
            var attributes = [NSFontAttributeName: usernameFont,
                              NSForegroundColorAttributeName: usernameColor]
            
            if let term = searchTerm?.lowercaseString {
                if user.username?.lowercaseString.rangeOfString(term) == nil {
                    attributes[NSForegroundColorAttributeName] = usernameGrayColor
                }
            }
            
            let usernameText = NSAttributedString(string: user.username + ", ",
                                                  attributes: attributes)
            finalText.appendAttributedString(usernameText)
        }
        
        heardByLabel.attributedText = finalText
    }
    
    private func updateWithSearchTerm() {
        setupUsernameText()
        setupHeardByString()
    }

    // MARK: Interface Actions
    
    @IBAction func UserImageTapped(sender: UIButton) {
        let controller = AppData.sharedInstance.navigationManager.controllerForType(.Profile) as! ProfileViewController
        controller.user = quote?.owner
        if let navController = AppData.sharedInstance.navigationManager.selectedViewController as? NavigationController {
            navController.pushViewController(controller, animated: true)
        }
    }
    
}
