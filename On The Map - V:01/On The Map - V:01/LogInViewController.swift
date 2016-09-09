//
//  LogInViewController.swift
//  On The Map - V:01
//
//  Created by Sneha gindi on 20/08/16.
//  Copyright © 2016 Sneha gindi. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var logInButton: LoginButton!
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    func taskForSessionID(email: String, password: String){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        print("{\"udacity\": {\"username\": \(email), \"password\": \(password)}}")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            let httpResponse = response as! NSHTTPURLResponse
            
            if httpResponse.statusCode != 200 { // Handle error…
            
                let alert = UIAlertController(title: "Oops!", message: "Your details seem to be wrong", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Let me try again!", style: UIAlertActionStyle.Default, handler: nil))
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("showTabBar", sender: self)
            })
        }
        
        task.resume()
    }
    @IBAction func loginButtonPressed(sender: AnyObject) {
        taskForSessionID(emailTF.text!, password: passwordTF.text!)
    }
        
}