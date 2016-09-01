//
//  CreateQuoteViewController.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class CreateQuoteViewController: ViewController {

    // MARK: Outlets
    @IBOutlet weak var textView: TextView!
    
    // MARK: Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "QUOTES"
        
        textView.placeholder = "Say something..."
        textView.placeholderColor = .whiteColor()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
