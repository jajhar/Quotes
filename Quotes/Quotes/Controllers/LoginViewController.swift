//
//  LoginViewController.swift
//  Quotes
//
//  Created by James Ajhar on 9/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: ViewController {
    
    // MARK: Outlets
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet weak var usernameTextField: TextFieldResignOnMiss!
    @IBOutlet weak var passwordTextField: TextFieldResignOnMiss!
    
    // Properties

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "RegisterSegue" {
            if let controller = segue.destinationViewController as? RegisterViewController {
                controller.delegate = self
            }
        }
    }
    
    // MARK: Actions
    @IBAction func logInPressed(sender: UIButton?) {
        
        if self.usernameTextField.text?.characters.count == 0 {
            let alert = UIAlertController(title: "Login Failed!", message: "Please enter your username or email address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if self.passwordTextField.text?.characters.count == 0 {
            let alert = UIAlertController(title: "Login Failed!", message: "Please enter your password.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        PKAPILogin().loginUser(usernameTextField.text!, password: passwordTextField.text!, completion: { (obj) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
            
            if(obj != nil) {
                
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                self.presentApp()
                
            } else {
                let alert = UIAlertController(title: "Login Failed!", message: "Something went wrong here. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }) { (response, error) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
            
            if(error != nil) {
                print("ERROR: ", error)
            }
            
            let alert = UIAlertController(title: "Login Failed!", message: "Please check your login information and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func presentApp() {
        AppData.sharedInstance.presentApp()
    }

}

extension LoginViewController: RegisterViewControllerDelegate {
    
    func registrationFinished(controller: RegisterViewController, user: User) {
        self.navigationController?.popToRootViewControllerAnimated(false)
        presentApp()
    }
}

extension LoginViewController: UITextFieldDelegate {

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            self.logInPressed(nil)
        }
        
        return false
    }
}