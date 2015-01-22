//
//  ViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 12/6/14.
//  Copyright (c) 2014 Ido Ben-Natan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBLoginViewDelegate {

    
    @IBOutlet var fbLoginView : FBLoginView!
    let manager = AFHTTPRequestOperationManager()
    var user : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Facebook Delegate methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("Logged In User")
        println("Performe Segue here!")
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println("User \(user)")
        println("access token: \(FBSession.activeSession().accessTokenData.accessToken)")
        println("expires at: \(FBSession.activeSession().accessTokenData.expirationDate)")
        

        manager.POST("http://music-hasalon-api.herokuapp.com/sessions", parameters: [
            "access_token": FBSession.activeSession().accessTokenData.accessToken,
            "expires_in": FBSession.activeSession().accessTokenData.expirationDate
            ], constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
                self.user = responseObject as NSDictionary
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
            })

        
        
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("Logged Out User")
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("Error: \(error.localizedDescription)")
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue")
        if segue.identifier == "loginSegue" {
            println("login segue")
            let navController : UINavigationController = segue.destinationViewController as UINavigationController
            println("navController")
            let partiesTVC : PartiesTableViewController = navController.viewControllers[0] as PartiesTableViewController
            println("Parties controller")
            partiesTVC.user = self.user as NSDictionary?
            println("user view controller: \(self.user)")
        }
    }

}

