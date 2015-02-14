//
//  FindPartyViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/22/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class FindPartyViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    let manager = AFHTTPRequestOperationManager()
    var party: Party?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        //sleep(5)
        manager.GET("http://music-hasalon-api.herokuapp.com/parties/\(textField.text)", parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            
            if let quote = responseObject?.objectForKey("party")? as? NSDictionary {
                self.party = Party(party: quote)
                self.performSegueWithIdentifier("segueFindParty", sender: self)
            }
            
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
        
    }
//    @IBAction func buttonClicked(sender: AnyObject) {
//        self.performSegueWithIdentifier("segueFindParty", sender: self)
//    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueFindParty" {
            let controller = segue.destinationViewController as NotMyPartyTableViewController
            controller.party = self.party!
        }
    }

}
