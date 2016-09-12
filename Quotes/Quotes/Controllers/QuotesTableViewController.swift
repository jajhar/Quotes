//
//  QuotesViewController.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import CoreData
import ILRemoteSearchBar
import MBProgressHUD

class QuotesTableViewController: UITableViewController {

    // MARK: Properties
    var searchBar: ILRemoteSearchBar = ILRemoteSearchBar(frame: CGRectZero)
    var searchButton: UIBarButtonItem!
    var searchTerm: String?
    
    lazy var quotesPager: QuotesPager = {
        return QuotesPager()
    }()
    
    lazy var searchPager: SearchPager = {
        return SearchPager()
    }()
    
    var activePager: Pager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "QUOTES"
        
        activePager = quotesPager

        // Setup TableView
        let nib = UINib(nibName: QuoteTableViewCell.NibName(), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: QuoteTableViewCell.CellIdentifier())
        tableView.registerClass(TableLoadingCell.self, forCellReuseIdentifier: "TableLoadingCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Setup Search Bar
        searchBar.setImage(UIImage(named: "SearchIcon"), forSearchBarIcon: .Search, state: .Normal)
        searchBar.setImage(UIImage(named: "xIcon"), forSearchBarIcon: .Clear, state: .Normal)
        searchBar.placeholder = "Search who said it or who heard it"
        searchBar.backgroundColor = .clearColor()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.timeToWait = 0.8
        searchBar.setSearchFieldBackgroundImage(nil, forState: .Normal)
        
        // Setup Search Button
        searchButton = UIBarButtonItem(image: UIImage(named: "SearchIcon"),
                                       style: .Plain,
                                       target: self,
                                       action: #selector(QuotesTableViewController.searchButtonPressed(_:)))
        navigationItem.rightBarButtonItem = searchButton
        
        // Listen for model changes
        NSNotificationCenter.defaultCenter().addObserverForName(kNotificationQuoteCreated,
                                                                object: nil,
                                                                queue: nil) { notif in
                                                                    self.reloadTableDataSource(clearState: true)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? NavigationController {
            navigationController.setTintColor(.redColor())
            navigationController.setTitleColor(.redColor())
            navigationController.makeOpaque()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func searchWithKeyword(keyword: String) {
        searchTerm = keyword
        searchPager.keyword = searchTerm
        activePager = searchPager
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        reloadTableDataSource(clearState: true)
    }
    
    // MARK: Interface Actions
    
    func searchButtonPressed(sender: UIBarButtonItem) {
        toggleSearchBar(true)
    }
    
    @IBAction func refreshControlActivated(sender: UIRefreshControl) {
        reloadTableDataSource(clearState: true)
    }
    
    // MARK: Helpers
    
//    func quotesTablePurged(notification: NSNotification) {
        // refresh the FRC
//        fetchedResultsController.
//        tableView.reloadData()
//    }
    
    func toggleSearchBar(show: Bool) {
        // Animated search bar display/hide
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.3
        fadeTextAnimation.type = kCATransitionFade
        navigationController?.navigationBar.layer.addAnimation(fadeTextAnimation, forKey: "searchFade")
        
        if show {
            navigationItem.titleView = searchBar
            navigationItem.rightBarButtonItem = nil
            searchBar.becomeFirstResponder()
        } else {
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = searchButton
        }
    }
    
    func reloadTableDataSource(clearState clear: Bool) {
        
        let block :PagerCompletionBlock = { (newQuotes, error) -> Void in
            self.refreshControl?.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: false)
            
            // error checking
            if(error != nil) {
                print("Error: \(error)")
            } else {
                self.tableView.reloadData()
            }
        }

        if(clear) {
            activePager.reloadWithCompletion(block)
        } else {
            activePager.getNextPageWithCompletion(block)
        }
    }

}

extension QuotesTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cnt = activePager.elements.count
        
        if !activePager.isEndOfPages {
            return cnt + 1
        }
        
        return cnt
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cnt = activePager.elements.count

        if indexPath.row >= cnt {
            // loading cell
            let cell = tableView.dequeueReusableCellWithIdentifier("TableLoadingCell")!
            reloadTableDataSource(clearState: false)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.CellIdentifier()) as! QuoteTableViewCell
        cell.quote = activePager.elements[indexPath.row] as? Quote
        cell.searchTerm = searchTerm
        cell.delegate = self
        return cell
    }
}

extension QuotesTableViewController: QuoteTableViewCellDelegate {
   
    func userWasTapped(cell: QuoteTableViewCell, user: User) {
        let controller = AppData.sharedInstance.navigationManager.controllerForType(.Profile) as! ProfileViewController
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension QuotesTableViewController: ILRemoteSearchBarDelegate {
    
    func remoteSearchBar(searchBar: ILRemoteSearchBar!, textDidChange searchText: String!) {
        searchWithKeyword(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        toggleSearchBar(false)
        searchTerm = nil
        activePager = quotesPager
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        searchWithKeyword(text)
    }
}
