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
    
    lazy var quotesPager: UserQuotesPager = {
        return UserQuotesPager()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Setup tableview
        let nib = UINib(nibName: QuoteTableViewCell.NibName(), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: QuoteTableViewCell.CellIdentifier())
        tableView.registerClass(TableLoadingCell.self, forCellReuseIdentifier: TableLoadingCell.CellIdentifier())
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
        
        profileHeaderView.user = user
        quotesPager.user = user
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func syncToUser() {
        navigationItem.title = user?.username
    }
    
    func reloadTableDataSource(clearState clear: Bool) {
        
        let block :PagerCompletionBlock = { (newQuotes, error) -> Void in
//            self.refreshControl?.endRefreshing()
            
            // error checking
            if(error != nil) {
                print("Error: \(error)")
            } else {
                self.tableView.reloadData()
            }
        }
        
        if(clear) {
            quotesPager.reloadWithCompletion(block)
        } else {
            quotesPager.getNextPageWithCompletion(block)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cnt = quotesPager.elements.count
        
        if !quotesPager.isEndOfPages {
            return cnt + 1
        }
        
        return cnt
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cnt = quotesPager.elements.count
        
        if indexPath.row >= cnt {
            // loading cell
            let cell = tableView.dequeueReusableCellWithIdentifier("TableLoadingCell")!
            reloadTableDataSource(clearState: false)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.CellIdentifier()) as! QuoteTableViewCell
        cell.quote = quotesPager.elements[indexPath.row] as? Quote
        return cell
    }
}
