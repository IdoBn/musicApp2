//
//  Request.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/12/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import Foundation

class Request {
    
    // properties
    
    let id: Int
    let author: String
    let partyId: Int
    let thumbnail: UIImage
    let thumbnailString: String
    let url: String
    let createdAt: NSDate
    let title: String
    let user: User?
    let likes = [Like]()
    
    // constructors
    
    init(id: Int, author: String, partyId: Int, thumbnail: String, url: String, createdAt: String, title: String, user: User?, likes: [Like]) {
        self.id = id
        self.author = author
        self.partyId = partyId
        self.title = title
        self.user = user
        self.likes = likes
        self.thumbnailString = thumbnail
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        self.createdAt = dateFormatter.dateFromString(createdAt)!
        
        let url1 = NSURL(string: thumbnail)
        let data = NSData(contentsOfURL: url1!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.thumbnail = UIImage(data: data!)!
        self.url = url
    }
    
    init(request: NSDictionary) {
        self.id = request.objectForKey("id") as Int
        self.author = request.objectForKey("author") as String
        self.partyId = request.objectForKey("party_id") as Int
        self.title = request.objectForKey("title") as String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        self.createdAt = dateFormatter.dateFromString(request.objectForKey("created_at") as String)!
        
        self.thumbnailString = request.objectForKey("thumbnail") as String
        let url = NSURL(string: request.objectForKey("thumbnail") as String)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.thumbnail = UIImage(data: data!)!
        
        if request.objectForKey("user") != nil {
            self.user = User(user: request.objectForKey("user") as NSDictionary)
        }
        
        //self.likes = request.objectForKey("likes") as? Array
        if let tempLikes = request.objectForKey("likes") as? [NSDictionary] {
            for like in tempLikes {
                self.likes.append(Like(like: like as NSDictionary))
            }
        }
        
        self.url = request.objectForKey("url") as String
    }
}