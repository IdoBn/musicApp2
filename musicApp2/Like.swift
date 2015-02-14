//
//  Like.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 2/8/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import Foundation

/*
{
  id: 197,
    user: {
      id: 1,
      name: "Ido Ben-Natan",
      email: "ido.bennatan@gmail.com",
      thumbnail: "http://graph.facebook.com/100000140820005/picture"
  }
}
*/

class Like {
    var id: Int
    var user: User
    
    init(like: NSDictionary) {
        self.id = like.objectForKey("id") as Int
        self.user = User(user: like.objectForKey("user") as NSDictionary)
    }

}