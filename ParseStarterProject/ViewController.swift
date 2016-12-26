/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController
{
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func loginButton(_ sender: Any)
    {
        if usernameField.text! != ""
        {
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!, block: {( user, error ) in
                if error != nil
                {
                    var errorMessage = "Login failed - please try again"
                    if let parseError = (error! as NSError).userInfo["error"] as? String
                    {
                        errorMessage = parseError
                    }
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert )
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    print("Logged In")
                    self.redirectUser()
                    
                }
            })
        }
        
    }
    
    @IBAction func signUpButton(_ sender: Any)
    {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        let acl = PFACL()
        acl.getPublicWriteAccess = true
        acl.getPublicReadAccess = true
        user.acl = acl
        
        user.signUpInBackground(block: {(success, error) in
            if error != nil
            {
                var errorMessage = "Signup failed - please try again"
                if let parseError = (error! as NSError).userInfo["error"] as? String
                {
                    errorMessage = parseError
                }
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert )
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print("Signed Up")
                self.performSegue(withIdentifier: "goToUserInfo", sender: self)
            }
        })

    }
    override func viewDidAppear(_ animated: Bool)
    {
        redirectUser()
    }
    func redirectUser()
    {
        if PFUser.current() != nil
        {
            if PFUser.current()?["isFemale"]  != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["photo"] != nil
            {
                performSegue(withIdentifier: "swipeFromInitialSegue", sender: self)
            }
            else
            {
                performSegue(withIdentifier: "goToUserInfo", sender: self)
            }
            
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
