//
//  SearchRequestViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/24/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class SearchRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var party: Party!
    var searchResults: [Request] = []
    let manager = AFHTTPRequestOperationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRequests()
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
                    
                    self.searchResults.append(Request(id: 0, author: author, partyId: self.party.id, thumbnail: thumbnail, url: url, createdAt: "2015-01-24T19:00:05.875Z", title: title, user: nil, likes: nil))
                }
                
                println(self.searchResults)
                self.tableView.reloadData()
            }
            
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    // MARK: -Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.searchResults.count
        }*/
//        return party.requests.count
        return self.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as? UITableViewCell
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "searchCell")
        var cell = self.tableView.dequeueReusableCellWithIdentifier("searchCell") as? UITableViewCell
        
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "searchCell")
        }
        
        /*if tableView == self.searchDisplayController?.searchResultsTableView {
            // image
            cell.imageView?.image = self.searchResults[indexPath.row].thumbnail
            // title
            cell.textLabel!.text = self.searchResults[indexPath.row].title
            
            return cell
        }*/
        
        // image
        cell!.imageView?.image = self.searchResults[indexPath.row].thumbnail
        // title
        cell!.textLabel!.text = self.searchResults[indexPath.row].title

        return cell!
    }
    
    // MARK: - Search
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
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
        }
    }

}
