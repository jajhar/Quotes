//
//  TableViewCell.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    class func CellIdentifier() -> String {
        return "DefaultIdentifier"
    }
    
    class func NibName() -> String {
        return "DefaultTableViewCell"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        // override as necessary
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
