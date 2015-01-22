//
//  Party.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/12/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import Foundation

class Party {
    let id: Int
    let name: String
    let user: User?
    let requests: [Request] = []
    
    init(party: NSDictionary) {
        self.id = party.objectForKey("id") as Int
        self.name = party.objectForKey("name") as String
        
        if let tempUser = party.objectForKey("user")? as? NSDictionary {
            self.user = User(user: (party.objectForKey("user") as NSDictionary))
        }
        
        if let tempRequest = party.objectForKey("requests") as? [NSDictionary] {
            for request in tempRequest {
                self.requests.append(Request(request: request as NSDictionary))
            }
        }
    }
}