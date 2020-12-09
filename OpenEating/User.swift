//
//  User.swift
//  OpenEating
//
//  Created by Laurel Wanger on 12/9/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

class User {
    var firstName: String
    var lastName: String
    var userEmail: String
    var userDocRef: String
    
    init(firstName: String, lastName: String, userEmail: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userEmail = userEmail
        self.userDocRef = ""
    }
    
}
