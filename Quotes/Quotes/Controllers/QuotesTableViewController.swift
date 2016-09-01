//
//  QuotesViewController.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import CoreData

class QuotesTableViewController: UITableViewController {

    // MARK: Properties
    var searchBar: UISearchBar = UISearchBar(frame: CGRectZero)
    var searchButton: UIBarButtonItem!
    var searchTerm: String?
    
    lazy var quotesPager: QuotesPager = {
        return QuotesPager()
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Quote")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "QUOTES"
        
        // Setup TableView
        let nib = UINib(nibName: QuoteTableViewCell.NibName(), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: QuoteTableViewCell.CellIdentifier())
        tableView.registerClass(TableLoadingCell.self, forCellReuseIdentifier: "TableLoadingCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Setup Search Bar
        searchBar.setImage(UIImage(named: "SearchIcon"), forSearchBarIcon: .Search, state: .Normal)
        searchBar.setImage(UIImage(named: "xIcon"), forSearchBarIcon: .Clear, state: .Normal)
        searchBar.placeholder = "Search who said it or who heard it"
        searchBar.backgroundColor = .clearColor()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.setSearchFieldBackgroundImage(nil, forState: .Normal)
        
        fetchData()
        
        // Setup Search Button
        searchButton = UIBarButtonItem(image: UIImage(named: "SearchIcon"), style: .Plain, target: self, action: #selector(QuotesTableViewController.searchButtonPressed(_:)))
        navigationItem.rightBarButtonItem = searchButton
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
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
    
    func fetchData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error {
            print("Error fetching feeds locally: \(error)")
        }
    }
    
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
            
            // error checking
            if(error != nil) {
                print("Error: \(error)")
            }
        }

        if(clear) {
            quotesPager.reloadWithCompletion(block)
        } else {
            quotesPager.getNextPageWithCompletion(block)
        }
    }

}

extension QuotesTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cnt = fetchedResultsController.fetchedObjects?.count != nil ? fetchedResultsController.fetchedObjects!.count : 0
        
        if !quotesPager.isEndOfPages {
            return cnt + 1
        }
        
        return cnt
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cnt = fetchedResultsController.fetchedObjects?.count != nil ? fetchedResultsController.fetchedObjects!.count : 0

        if indexPath.row >= cnt {
            // loading cell
            let cell = tableView.dequeueReusableCellWithIdentifier("TableLoadingCell")!
            reloadTableDataSource(clearState: false)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.CellIdentifier()) as! QuoteTableViewCell
        cell.quote = fetchedResultsController.objectAtIndexPath(indexPath) as? Quote
        cell.searchTerm = searchTerm
        return cell
    }
}

extension QuotesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        print("didChangeSection:  ")

        switch type {
        case .Insert:
            print("Insert")
            let sections = NSIndexSet(index: sectionIndex)
            tableView.insertSections(sections, withRowAnimation: .Fade)
        case .Update:
            print("Updated")
        case .Move:
            print("Moved")
        case .Delete:
            print("Delete")
            let sections = NSIndexSet(index: sectionIndex)
            tableView.deleteSections(sections, withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print("didChangeObject:  ")
        switch type {
        case .Insert:
            print("Insert")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            print("Updated")
            if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? QuoteTableViewCell {
                cell.quote = fetchedResultsController.objectAtIndexPath(indexPath!) as? Quote
            }
        case .Move:
            print("Moved")
        case .Delete:
            print("Delete")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

extension QuotesTableViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        toggleSearchBar(false)
        searchTerm = searchBar.text
        tableView.reloadData()
    }
}
