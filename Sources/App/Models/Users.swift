//
//  Users.swift
//  tracker-apiPackageDescription
//
//  Created by Arjay Jones on 1/10/18.
//

import Foundation

final class Users {
    
    // Properties
    let UserID:    Int
    let FirstName: String
    let LastName:  String
    let EMail:     String
    let Password:  String
    
    // Initializer
    init(userID: Int, firstName: String, lastName: String, email: String, password: String) {
        self.UserID    = userID
        self.FirstName = firstName
        self.LastName  = lastName
        self.EMail     = email
        self. Password = password
    }
}
