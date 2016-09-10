//
//  QuoteTableViewCell.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import SDWebImage

protocol QuoteTableViewCellDelegate {
    func userWasTapped(cell: QuoteTableViewCell, user: User)
}

class QuoteTableViewCell: TableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var heardByTextView: UITextView!
    @IBOutlet weak var usernameButton: UIButton!
    
    // MARK: Properties
    var quote: Quote? {
        didSet {
            syncToQuote()
        }
    }
    
    var delegate: QuoteTableViewCellDelegate?
    let taggedUserAttributeKey = "TaggedUser"
    
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
        quoteTextView.removePadding()
        heardByTextView.removePadding()
        
        // fixe
        usernameButton.contentEdgeInsets = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(QuoteTableViewCell.textViewTapped(_:)))
        heardByTextView.addGestureRecognizer(tapRecognizer)

    }
    
    private func syncToQuote() {
        
        dateLabel.text = quote?.convertedDateString
        
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
        usernameButton.setTitle(quote?.saidBy?.username, forState: .Normal)
        usernameButton.setTitleColor(.blackColor(), forState: .Normal)

        if let term = searchTerm?.lowercaseString {
            if quote?.saidBy?.username?.lowercaseString.rangeOfString(term) == nil {
                usernameButton.setTitleColor(.lightGrayColor(), forState: .Normal)
            }
        }
    }
    
    private func setupQuotationText() {
        guard let quoteText = quote?.text else { return }
        quoteTextView.attributedText = NSAttributedString.AttributedStringWithRightQuotation(quoteText, attributes: nil)
    }
    
    private func setupHeardByString() {
        
        guard let heardBy = quote?.heardBy else { return }
        
        let titleColor = UIColor.lightGrayColor()
        let usernameFont = UIFont.boldSystemFontOfSize(14.0)
        let usernameColor = UIColor.blackColor()
        let usernameGrayColor = UIColor.lightGrayColor()

        // Setup attributed string
        let titleText = NSAttributedString(string: "Heard by: ",
                                           attributes: [NSForegroundColorAttributeName: titleColor])
        
        let finalText = NSMutableAttributedString(attributedString: titleText)
        
        for user in heardBy {
            
            guard let user = user as? User else { continue }
            guard let username = user.username else { continue }

            var attributes = [NSFontAttributeName: usernameFont,
                              NSForegroundColorAttributeName: usernameColor,
                              taggedUserAttributeKey: user]

            
            if let term = searchTerm?.lowercaseString {
                if user.username?.lowercaseString.rangeOfString(term) == nil {
                    attributes[NSForegroundColorAttributeName] = usernameGrayColor
                }
            }
            
            let usernameText = NSAttributedString(string: username + ", ",
                                                  attributes: attributes)
            finalText.appendAttributedString(usernameText)
        }
        
        
//        finalText.deleteCharactersInRange(finalText.string.rangeOfComposedCharacterSequenceAtIndex(finalText.length-1))
        
        heardByTextView.attributedText = finalText
    }
    
    func textViewTapped(recognizer: UITapGestureRecognizer) {
        
        if let textView = recognizer.view as? UITextView {
            let layoutManager = textView.layoutManager
            var location: CGPoint = recognizer.locationInView(textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            
            let charIndex = layoutManager.characterIndexForPoint(location,
                                                                 inTextContainer: textView.textContainer,
                                                                 fractionOfDistanceBetweenInsertionPoints: nil)
            
            if charIndex < textView.textStorage.length {
                var range = NSRange(location: 0, length: 0)
                
                if let userObj = textView.attributedText?.attribute(taggedUserAttributeKey,
                                                             atIndex: charIndex,
                                                             effectiveRange: &range) as? User {
                    delegate?.userWasTapped(self, user: userObj)
                }
                
            }
        }
    }

    private func updateWithSearchTerm() {
        setupUsernameText()
        setupHeardByString()
    }

    // MARK: Interface Actions
    
    @IBAction func usernameTapped(sender: UIButton) {
        guard let saidBy = quote?.saidBy else { return }
        delegate?.userWasTapped(self, user: saidBy)
    }
    
    @IBAction func UserImageTapped(sender: UIButton) {
        guard let owner = quote?.owner else { return }
        delegate?.userWasTapped(self, user: owner)
    }
    
}
