//
//  NotMyPartyTableViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/22/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class NotMyPartyTableViewController: UITableViewController, PTPusherDelegate {
    
    var party: Party?
    var pusherClient = PTPusher()
    let manager = AFHTTPRequestOperationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = party!.name
        
        
        
        
        
        pusherClient = PTPusher.pusherWithKey("27aa526da1424bb735a4", delegate: self, encrypted: false) as PTPusher
        
        var pusherChannel = pusherClient.subscribeToChannelNamed("\(self.party!.id)") as PTPusherChannel
        
        pusherChannel.bindToEventNamed("request_liked", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("liked! \(newRequest)")
            self.loadParty()
        })
        
        pusherChannel.bindToEventNamed("request_unliked", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("unliked! \(newRequest)")
            self.loadParty()
        })
        
        pusherChannel.bindToEventNamed("request_created", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("created! \(newRequest)")
            self.loadParty()
        })
        
        pusherChannel.bindToEventNamed("request_played", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("played! \(newRequest)")
            
            self.loadParty()
        })
        
        pusherChannel.bindToEventNamed("request_destroyed", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("destroyed! \(newRequest)")
            
            self.loadParty()
        })
        
        self.pusherClient.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadParty() {
        manager.GET("http://music-hasalon-api.herokuapp.com/parties/\(self.party!.id)", parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            
            if let quote = responseObject?.objectForKey("party")? as? NSDictionary {
                self.party = Party(party: quote)
                self.tableView.reloadData()
            }
            
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let count = party?.requests.count
        return count!
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("partyCell", forIndexPath: indexPath) as UITableViewCell

        // image
        cell.imageView?.image = self.party?.requests[indexPath.row].thumbnail
        // title
        cell.textLabel!.text = self.party?.requests[indexPath.row].title
//        // description
//        cell.detailTextLabel?.text = self.party?.requests[indexPath.row].user?.name

        return cell
    }
    
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedRequest = self.party?.requests[indexPath.row]
//        var alert = UIAlertController(title: selectedRequest!.title, message: "Vote for songs you like!", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Vote Up!", style: UIAlertActionStyle.Default, handler: {
//            alertView in
//            println("up voted!!!!")
//        }))
//        alert.addAction(UIAlertAction(title: "Unvote", style: UIAlertActionStyle.Default, handler: {
//            alertView in
//            println("unvoted!!!!!")
//        }))
//        
//        self.presentViewController(alert, animated: true, completion: nil)
//    }

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
        if segue.identifier == "segueSearch" {
            let navController : UINavigationController = segue.destinationViewController as UINavigationController
            let searchVC : SearchViewController = navController.viewControllers.first as SearchViewController
            searchVC.party = self.party!
        }
        
        if segue.identifier == "showRequest" {
            let navController = segue.destinationViewController as UINavigationController
            let showReqVC = navController.viewControllers.first as ShowRequestViewController
            let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell)
            
            if let request = self.party?.requests[selectedIndex!.row] {
                showReqVC.request = request
            }
        }
    }

}
