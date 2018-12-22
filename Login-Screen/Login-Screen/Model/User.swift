//
//  File.swift
//  Login-Screen
//
//  Created by Clayton Hebert on 11/29/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class User{
    public var uid: String!
    public var groups: [String]
    public var firstName:String!
    public var lastName:String!
    public var friends: [String]
    public var allUsers: [String]
    public var activities: [String]
    public var profilePic: String!
    
    init(uid: String, groups: [String], first: String, last: String, friends: [String], allUsers: [String], activities: [String], profilePic: String)
    {
        self.uid=uid
        self.groups=groups
        self.firstName=first
        self.lastName=last
        self.friends=friends
        self.allUsers = allUsers
        self.activities = activities
        self.profilePic = profilePic
    }
    
}
