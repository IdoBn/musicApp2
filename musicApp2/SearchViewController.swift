//
//  SearchViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/25/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var party: Party!
    var searchResults: [Request] = []
    let manager = AFHTTPRequestOperationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadRequests() {
        manager.GET("http://music-hasalon-api.herokuapp.com/parties/\(self.party.id)/search", parameters: ["songpull": self.searchBar.text], success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            
            if let quote = responseObject?.objectForKey("videos")? as? [NSDictionary] {
                self.searchResults = []
                for requestDict in quote {
                    let author = requestDict.objectForKey("author")?.objectForKey("name") as String
                    let thumbnail = ((requestDict.objectForKey("thumbnails") as NSArray).firstObject as NSDictionary).objectForKey("url") as String
                    let title = requestDict.objectForKey("title") as String
                    let url = requestDict.objectForKey("player_url") as String
                    
                    self.searchResults.append(Request(id: 0, author: author, partyId: self.party.id, thumbnail: thumbnail, url: url, createdAt: "2015-01-24T19:00:05.875Z", title: title, user: nil, likes: [Like]()))
                }
                
                println(self.searchResults)
                self.tableView.reloadData()
                self.searchDisplayController!.searchResultsTableView.reloadData()
            }
            
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "searchCell")
        }
        
        //we know that cell is not empty now so we use ! to force unwrapping
        
        // image
        cell!.imageView?.image = self.searchResults[indexPath.row].thumbnail
        // title
        cell!.textLabel!.text = self.searchResults[indexPath.row].title
        
        return cell!
    }
    
    func loadParty() {
        manager.GET("http://music-hasalon-api.herokuapp.com/parties/\(self.party!.id)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if let quote = responseObject?.objectForKey("party")? as? NSDictionary {
                    self.party = Party(party: quote)
                    self.performSegueWithIdentifier("backFromSearch", sender: self)
                } else {
                    println("no quote")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected: Request = self.searchResults[indexPath.row] as Request
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let params = [
            "request": ["title" : selected.title,
                "author": selected.author,
                "url": selected.url,
                "party_id": selected.partyId,
                "thumbnail": selected.thumbnailString
            ],
            "user_access_token": (appDelegate.user!["access_token"] as String)
        ]
        
        manager.POST("http://music-hasalon-api.herokuapp.com/requests", parameters: params, constructingBodyWithBlock: nil, success: {
                (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("create success \(responseObject)")
                self.loadParty()
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("delete error \(error)")
                self.loadParty()
                
        })
    }
    
    // MARK: - Search
    
//    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
//        self.loadRequests()
//        return true
//    }
    
    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        self.loadRequests()
//    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.loadRequests()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "backFromSearch" {
        let notMyVC : NotMyPartyTableViewController = segue.destinationViewController as NotMyPartyTableViewController
            notMyVC.party = self.party
            println(self.party.requests.last?.title)
            notMyVC.tableView.reloadData()
        }
    }

}
