//
//  User.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/12/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import Foundation
import JSON

class User {
    
    // properties
    let id: Int
    let name: String
    let email: String?
    let thumbnail: UIImage
    let largeThumbnail: UIImage
    
    // constructor
    
    init(id: Int, name: String, email: String?, thumbnail: String) {
        
        self.id = id
        self.name = name
        
        if email != nil {
            self.email = email
        }
        
        let url = NSURL(string: thumbnail)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.thumbnail = UIImage(data: data!)!
        
        let largeUrl = NSURL(string: thumbnail + "?type=large")
        let largeData = NSData(contentsOfURL: largeUrl!)
        self.largeThumbnail = UIImage(data: largeData!)!
    }
    
    init(user: Data) {
        let jsonUser = JSON(data: user)
    }
    
    init(user: NSDictionary) {
        self.id = user.objectForKey("id") as Int
        self.name = user.objectForKey("name") as String
        
        if let email: AnyObject = user.objectForKey("email")?{
            self.email = email as? String
        }
        
        let urlString = user.objectForKey("thumbnail") as String
        let url = NSURL(string: urlString)
        let data = NSData(contentsOfURL: url!)
        self.thumbnail = UIImage(data: data!)!
        
        let largeUrl = NSURL(string: urlString + "?type=large")
        let largeData = NSData(contentsOfURL: largeUrl!)
        self.largeThumbnail = UIImage(data: largeData!)!
    }
    
    // methods
//    private func loadThumbnail(urlString: String) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULTgy78, 0)) {
//            // do some task
//            let url = NSURL(string: urlString)
//            let data = NSData(contentsOfURL: url!)
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                // update some UI
//                self.thumbnail = UIImage(data: data!)!
//            }
//        }
//    }
}