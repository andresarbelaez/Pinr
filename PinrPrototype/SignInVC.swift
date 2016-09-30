//
//  SignInVC.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/25/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class SignInVC: UIViewController {

    @IBOutlet weak var usernameField: UITextView!
    @IBOutlet weak var passwordField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: AnyObject) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        PFUser.logInWithUsername(inBackground: username, password: password) { (PFUser, Error) in
            if let Error = Error {
                print("User login failed.")
                print("Wrong username and/or password")
                print(Error.localizedDescription)
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "SignInSegue", sender: nil)
                // display view controller that needs to shown after successful login
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
