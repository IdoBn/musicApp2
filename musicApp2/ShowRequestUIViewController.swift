//
//  ShowRequestViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 2/8/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class ShowRequestViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "UploaderCell", bundle: nil)
        tableView.registerNib(nib!, forCellReuseIdentifier: "uploaderCell")
        
        self.title = self.request!.title
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.request!.likes.count
        default:
            return 0
        }
//        return 1 + self.request!.likes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("uploaderCell") as UploaderTableViewCell
            cell.uploaderName.text = request?.user?.name
            cell.uploaderImage.image = request?.user?.largeThumbnail
            cell.numberOfVotes.text = "votes: \(request!.likes.count)"
            cell.voteHandler = { button in
                println("handling vote!!!!")
            }
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("likeCell") as UITableViewCell
            cell.textLabel?.text = self.request?.likes[indexPath.row ].user.name
            cell.imageView?.image = self.request?.likes[indexPath.row ].user.thumbnail
            println(self.request?.likes[indexPath.row].user.name)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String? = nil
        switch section {
        case 0:
            sectionName = "Requested by:"
            break;
        case 1:
            if self.request?.likes.count > 0 {
                sectionName =  "Liked by:"
            } else {
                sectionName = ""
            }
            break;
        default:
            sectionName = ""
            break;
        }
        return sectionName
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
