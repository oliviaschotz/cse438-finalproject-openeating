//
//  User.swift
//  OpenEating
//
//  Created by Laurel Wanger on 12/9/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var userEmail: String
    var userDocRef: String
    
    init(name: String, userEmail: String) {
        self.name = name
        self.userEmail = userEmail
        userDocRef = ""
    }
    
}
