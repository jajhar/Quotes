//
//  RegisterViewController.swift
//  Quotes
//
//  Created by James Ajhar on 9/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol RegisterViewControllerDelegate {
    func registrationFinished(controller: RegisterViewController, user: User)
}

class RegisterViewController: ViewController {

    // MARK: Outlets
    @IBOutlet weak var usernameTextField: TextFieldResignOnMiss!
    @IBOutlet weak var passwordTextField: TextFieldResignOnMiss!
    @IBOutlet weak var phoneTextField: TextFieldResignOnMiss!

    // MARK: Properties
    var delegate: RegisterViewControllerDelegate?
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        
        if usernameTextField.text == nil || usernameTextField.text?.characters.count < 3 {
            let sheet : UIAlertController = UIAlertController(title: "Error", message: "Username must be at least 3 characters", preferredStyle: .Alert)
            
            let dismissAction : UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
                //Just dismiss the action sheet
            }
            sheet.addAction(dismissAction)
            presentViewController(sheet, animated:true, completion:nil)
            return
        }
                
        if passwordTextField.text == nil || passwordTextField.text!.characters.count < 6 {
            let alert : UIAlertController = UIAlertController(title: "Error", message: "Passwords must be greater than 6 characters.", preferredStyle: .Alert)
            let dismissAction : UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(dismissAction)
            presentViewController(alert, animated:true, completion:nil)
            return
        }
        
        if phoneTextField.text == nil || phoneTextField.text!.characters.count < 6 {
            let alert : UIAlertController = UIAlertController(title: "Error", message: "Phone numbers must be greater than 6 characters.", preferredStyle: .Alert)
            let dismissAction : UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(dismissAction)
            presentViewController(alert, animated:true, completion:nil)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let phone = Int(phoneTextField.text!)!
        
        RegisterAPI().registerUser(usernameTextField.text!, password: passwordTextField.text!, phoneNumber: phone, completion: { (obj) -> Void in
            
            MBProgressHUD.hideHUDForView(self.view, animated: false)
            
            if let user = obj as? User {
                self.delegate?.registrationFinished(self, user: user)
                return
            }
            
            if let dict = obj as? NSDictionary {
                let message = dict.objectForKey("errorMessage") as! String
                let alert = UIAlertController(title: "Registration Failed!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            }, failure: { (response, error, message) -> Void in
                
                MBProgressHUD.hideHUDForView(self.view, animated: false)
                
                if(error != nil) {
                    print("ERROR: \(error)")
                }
                
                var msg = message
                if msg == nil {
                    msg = "Something went wrong here. Please try again."
                }
                
                let alert = UIAlertController(title: "Registration Failed!", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        })
        
    }
}
