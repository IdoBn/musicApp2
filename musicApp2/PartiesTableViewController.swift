//
//  PartiesTableViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 12/6/14.
//  Copyright (c) 2014 Ido Ben-Natan. All rights reserved.
//

import UIKit

class PartiesTableViewController: UITableViewController {
    
    var parties: [Party] = []
    let manager = AFHTTPRequestOperationManager()
    var user : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("parties tbc user: \(self.user)")

        let key = "id"
        println("http://music-hasalon-api.herokuapp.com/users/\(self.user![key]!)")
        
        manager.GET("http://music-hasalon-api.herokuapp.com/users/\(self.user![key]!)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                println(responseObject?.objectForKey("user")?.objectForKey("parties")?)
                if let quote = responseObject?.objectForKey("user")?.objectForKey("parties")? as? [NSDictionary] {
                    
                    for party in quote {
                        self.parties.append(Party(party: party))
                    }
                    
                    self.tableView.reloadData()
                } else {
                    println("no quote")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("partiesCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = self.parties[indexPath.row].name as String
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        println("segue parties controller")
        let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell)
        if segue.identifier == "partySegue" {
            if let index = selectedIndex? {
                let partyVC: PartyViewController = segue.destinationViewController as PartyViewController
                partyVC.party = self.parties[index.row] as Party
                partyVC.user = self.user
            }
        }
    }

}
