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
    var refreshControl: UIRefreshControl!
    
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
        
        if user == nil {
            // default to the logged in user
            user = AppData.sharedInstance.localSession?.localUser
        }
        
        // Setup tableview
        let nib = UINib(nibName: QuoteTableViewCell.NibName(), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: QuoteTableViewCell.CellIdentifier())
        tableView.registerClass(TableLoadingCell.self, forCellReuseIdentifier: TableLoadingCell.CellIdentifier())
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = UIView(frame: CGRectZero)

        // Setup header view
        profileHeaderView = ProfileHeaderView.loadFromNib()
        profileHeaderView.delegate = self
        headerContainerView.addSubview(profileHeaderView)
        profileHeaderView.frame = headerContainerView.bounds
        profileHeaderView.constrainToSuperview()
        
        // Add Pull to Refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProfileViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        var headerframe = headerContainerView.frame
        headerframe.size.height = 300.0

        if user == AppData.sharedInstance.localSession?.localUser {
            headerframe.size.height = 300.0
        } else {
            headerframe.size.height = 180.0
        }
        
        headerContainerView.frame = headerframe
        headerContainerView.layoutIfNeeded()
        
        profileHeaderView.user = user
        quotesPager.user = user
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? NavigationController {
            navigationController.setTintColor(.redColor())
            navigationController.setTitleColor(.redColor())
            navigationController.makeTransparent()
        }
    }
    
    private func syncToUser() {
        navigationItem.title = user?.username
    }
    
    func refresh(sender: AnyObject) {
        reloadTableDataSource(clearState: true)
    }
    
    func reloadTableDataSource(clearState clear: Bool) {
        
        let block :PagerCompletionBlock = { (newQuotes, error) -> Void in
            self.refreshControl.endRefreshing()
            
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
            let cell = tableView.dequeueReusableCellWithIdentifier("TableLoadingCell") as! TableLoadingCell
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.width*2, 0, 0)
            cell.showSpinner(false)
            reloadTableDataSource(clearState: false)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.CellIdentifier()) as! QuoteTableViewCell
        cell.quote = quotesPager.elements[indexPath.row] as? Quote
        cell.delegate = self
        return cell
    }
}

extension ProfileViewController: QuoteTableViewCellDelegate {
    
    func userWasTapped(cell: QuoteTableViewCell, user: User) {
        if user == self.user { return }
        let controller = AppData.sharedInstance.navigationManager.controllerForType(.Profile) as! ProfileViewController
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func saidByPressed(headerView: ProfileHeaderView, button: UIButton) {
        quotesPager.filter = .saidBy
        tableView.reloadData()
    }
    
    func heardByPressed(headerView: ProfileHeaderView, button: UIButton) {
        quotesPager.filter = .heardBy
        tableView.reloadData()
    }
}
