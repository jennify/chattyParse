//
//  ViewController.swift
//  chattyParse
//
//  Created by Jennifer Lee on 2/17/16.
//  Copyright © 2016 Jennifer Lee. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    let alertController = UIAlertController(title: "Action failed", message: "Message", preferredStyle: .Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) in
        })
        alertController.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLoginClick(sender: AnyObject) {
//        let email = emailField.text as String
        PFUser.logInWithUsernameInBackground( emailField.text!, password:passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("signedInSegue", sender: self)
                
            } else {
                // The login failed. Check error to see why.
                
                self.alertController.title = "Failed to log in"
                self.alertController.message = error!.userInfo["error"] as? String
                
                self.presentViewController(self.alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func onSignupClick(sender: AnyObject) {
        let user = PFUser()
        user.username = emailField.text
        user.password = passwordField.text
        user.email = emailField.text
        // other fields can be set just like with PFObject
        user["phone"] = "415-392-0202"
        
        user.signUpInBackgroundWithBlock {
        (succeeded: Bool, error: NSError?) -> Void in
        if let error = error {
                //let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            
                self.alertController.title = "Failed to sign up"
                self.alertController.message = error.userInfo["error"] as? String
                self.presentViewController(self.alertController, animated: true, completion: nil)
            } else {
                // Hooray! Let them use the app now.
                self.performSegueWithIdentifier("signedInSegue", sender: self)
            
            }
        }
    }
}

