//
//  RequestViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/30/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var requestImage: UIImageView!
    
    var request: Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = request.title
        requestImage.image = request.thumbnail
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.request.likes?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("requestCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "requestCell")
        }
        
        //we know that cell is not empty now so we use ! to force unwrapping
        
        // image
        //cell!.imageView?.image = self.request.likes[indexPath.row].thumbnail
        // title
        let likeDict: NSDictionary = self.request.likes![indexPath.row] as NSDictionary
        
        cell!.textLabel!.text = likeDict.objectForKey("user")?.objectForKey("name") as? String
        
        return cell!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
