//
//  ViewController.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/22/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.isHidden = false
        self.loginButton.delegate = self
        self.loginButton.readPermissions = ["email", "user_friends"]

        if (FBSDKAccessToken.current() == nil){
            print("no one logged in")
            
        } else {
            print("loggedin viewDidLoad")
            //callUser()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "LoginSegue", sender: nil)
        } else {
            UIView.animate(withDuration: 2.0, animations: {
                self.signinButton.alpha = 100
                self.signupButton.alpha = 100
                self.loginButton.alpha = 100
            })
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }

    func callUser() {
        let params = ["fields": "name, friends, picture.width(1000).height(1000), cover, bio, gender"]
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        self.loginButton.isHidden = true
        
        /*
        graphRequest.start(completionHandler: {(connection, resultss, error: NSError!) in
            
            var results = resultss as! NSDictionary
            if error == nil {
                self.gender = results["gender"] as! String
                var friendObjects = results["friends"] as! NSDictionary
                self.author_name=results["name"] as? String
                //print(friendObjects.valueForKey("data") as! NSArray)
                var friends = friendObjects.valueForKey("data") as! NSArray
                var frands:[String] = []
                for friend in friends {
                    var nam = friend.valueForKey("name")
                    frands.append(nam as! String)
                    self.newFriends.append(nam as! String)
                }
                print("\(friendObjects.count)")
                let pictureDict = results["picture"] as! NSDictionary
                let dataInPicDict = pictureDict["data"] as! NSDictionary
                let url = dataInPicDict["url"] as! String
                self.profilePictureURL = url as! String
                
                var coverURL = "www.google.com"
                if results.valueForKey("cover") != nil {
                    var coverDict = results["cover"] as! NSDictionary
                    coverURL = coverDict["source"] as! String
                    self.coverPictureURL = coverURL as! String
                }
                
                var query = PFQuery(className: "User")
                query.whereKey("displayName", equalTo: self.author_name!)
                query.findObjectsInBackgroundWithBlock { (userExists: [PFObject]?, error: NSError?) -> Void in
                    //
                    /*
                     if userExists?.count == 0 || userExists?.count == nil {
                     
                     User.createUser(url, friends: frands, coverURL: coverURL, bio: "", displayName: self.author_name, gender: self.gender, withCompletion:
                     { (success: Bool, error: NSError?) in
                     if success {
                     print("success user sent to Parse")
                     self.performSegueWithIdentifier("toTabBar", sender: nil)
                     } else {
                     print("There was an error: \(error?.localizedDescription)")
                     }
                     })
                     
                     } else if userExists?.count == 1 {
                     let completion: PFBooleanResultBlock = { (success: Bool, error: NSError?) in
                     
                     if success {
                     print("yay")
                     self.performSegueWithIdentifier("toTabBar", sender: nil)
                     
                     } else {
                     print("There was an error: \(error?.localizedDescription)")
                     }
                     }
                     var shouldChange = false
                     let user = userExists![0] as! PFObject
                     let oldFriends = user["friends"] as! [String]
                     for oldFriend in oldFriends {
                     if !self.newFriends.contains(oldFriend) {
                     shouldChange = true
                     }
                     }
                     for nf in self.newFriends{
                     if !oldFriends.contains(nf)
                     {
                     shouldChange = true
                     }
                     }
                     if shouldChange {
                     user["friends"] = self.newFriends
                     user.saveInBackgroundWithBlock(completion)
                     }else{
                     //self.performSegueWithIdentifier("toTabBar", sender: nil)
                     }
                     
                     } else {
                     print("user exists")
                     print(error?.localizedDescription)
                     //self.performSegueWithIdentifier("toTabBar", sender: nil)
                     }
                    */
                    //
                }
            } else {
                print("Error requesting friends list from facebook")
                print("\(error)")
            }
        })
  */
 }


    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        
        print("user logged out")
        //FBSDKAccessToken.setCurrent(nil)
        //FBSDKProfile.setCurrent(nil)
        let deletepermission = FBSDKGraphRequest(graphPath: "me/permissions/", parameters: nil, httpMethod: "DELETE")
        deletepermission?.start(completionHandler: {(connection,result,error)-> Void in print("the delete permission is \(result)") })
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.loginBehavior = FBSDKLoginBehavior.web
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let x = FBSDKAccessToken.current()
        print("ACCESS TOKEN22222", x)
        print("in this method")
        //self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        if error == nil {
            print("login complete logInButton")
            //self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        } else {
            print(error.localizedDescription)
            print("ERRORR")
        }
        if let userToken = result.token {
            print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
            //callUser()
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

