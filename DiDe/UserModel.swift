//
//  UserModel.swift
//  DiDe
//
//  Created by Deepak SK on 2/07/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
    
    let key:String
    let itemRef: FIRDatabaseReference?
    let email:String
    var displayName: String
    var relations: [NSDictionary]!
    
    var latitude: Double!
    var longitude: Double!
    var tracking: Int
    var trackedUser: String!
    
    init(snapshot:FIRDataSnapshot) {
        
        self.key = snapshot.key
        self.itemRef = snapshot.ref
        
        if let email = snapshot.value!["email"] as? String {
            self.email = email
        } else {
            self.email = ""
        }
        
        if let displayName = snapshot.value!["displayName"] as? String {
            self.displayName = displayName
        } else {
            self.displayName = ""
        }
        
        if let latitude = snapshot.value!["latitude"] as? Double {
            self.latitude = latitude
        } else {
            self.latitude = 0
        }
        
        if let longitude = snapshot.value!["longitude"] as? Double {
            self.longitude = longitude
        } else {
            self.longitude = 0
        }
        
        if let tracking = snapshot.value!["tracking"] as? Int {
            self.tracking = tracking
        } else {
            self.tracking = 0
        }
        
        if let trackedUser = snapshot.value!["trackedUser"] as? String {
            self.trackedUser = trackedUser
        } else {
            self.trackedUser = ""
        }
        
        if let relations = snapshot.value!["relations"] as? [NSDictionary] {
            self.relations = relations
        } else {
            self.relations = nil
        }
    }
    
    init (email:String, displayName: String, key: String = "", trackedUser: String = "") {
        self.key = key
        self.email = email
        self.displayName = displayName
        self.relations = nil
        self.itemRef = nil
        self.tracking = 0
        self.trackedUser = trackedUser
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "displayName": displayName,
            "email": email,
            // "relations": relations,
            "latitude": latitude,
            "longitude": longitude,
            "tracking": tracking,
            "trackedUser": trackedUser
        ]
    }
    
    func updateUser(user: User) {
        user.itemRef?.setValue(user.toAnyObject())
    }
    
    mutating func incrementTracking() {
        self.tracking += 1
        self.itemRef?.updateChildValues(["tracking": tracking])
    }
    
    mutating func decrementTracking() {
        
        self.tracking -= 1
        self.tracking = self.tracking < 0 ? 0 : self.tracking
        
        self.itemRef?.updateChildValues(["tracking": tracking])
    }
    
    func updateTrackedUser() {
        self.itemRef?.updateChildValues(["trackedUser": trackedUser])
    }
    
    func updateLocation() {
        self.itemRef?.updateChildValues(["latitude": latitude, "longitude": longitude])
    }
}
