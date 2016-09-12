//
//  TableLoadingCell.swift
//  Quotes
//
//  Created by James Ajhar on 8/31/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import MBProgressHUD

class TableLoadingCell: TableViewCell {
    
    var progressHUD : MBProgressHUD!
    
    override class func CellIdentifier() -> String {
        return "TableLoadingCell"
    }
    
    func showSpinner(animated: Bool) {
        progressHUD?.removeFromSuperview()
        progressHUD = MBProgressHUD(view: self.contentView)
        progressHUD.bezelView.color = .clearColor()
        progressHUD.bezelView.opaque = true
        self.contentView.addSubview(progressHUD)
        progressHUD.showAnimated(animated)
    }
    
    override func commonInit() {
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
    }
    
}