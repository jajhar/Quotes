//
//  ProfileViewController.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class ProfileViewController: ViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerContainerView: UIView!

    // MARK: Properties
    var profileHeaderView: ProfileHeaderView!
    var user: User? {
        didSet {
            syncToUser()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Setup tableview
        let nib = UINib(nibName: QuoteTableViewCell.NibName(), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: QuoteTableViewCell.CellIdentifier())
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Setup header view
        profileHeaderView = ProfileHeaderView.loadFromNib()
        headerContainerView.addSubview(profileHeaderView)
        profileHeaderView.frame = headerContainerView.bounds
        profileHeaderView.constrainToSuperview()
        
        if user == nil {
            // default to the logged in user
            user = AppData.sharedInstance.localSession?.localUser
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func syncToUser() {
        navigationItem.title = user?.username
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.CellIdentifier())!
        return cell
    }
}