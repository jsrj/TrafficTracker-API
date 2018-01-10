//
//  Users.swift
//  tracker-api
//
//  Created by Arjay Jones on 1/10/18.
//
import Foundation
import FluentProvider

final class Users: Model {
    let storage = Storage()
    
    // Properties <> Virtual Columns
    let UserID:    Int
    let UserUUID:  String
    let FirstName: String
    let LastName:  String
    let EMail:     String
    let Password:  String
    
    // Initializer
    init(userID: Int, userUUID: String, firstName: String, lastName: String, email: String, password: String) {
        self.UserID    = userID
        self.UserUUID  = userUUID
        self.FirstName = firstName
        self.LastName  = lastName
        self.EMail     = email
        self.Password = password
    }
    
    // Storable Protocol Specifics
    // DB <-> Swift
    init(row: Row) throws {
        UserID    = try row.get("UserID")
        UserUUID  = try row.get("UserUUID")
        FirstName = try row.get("FirstName")
        LastName  = try row.get("LastName")
        EMail     = try row.get("EMail")
        Password  = try row.get("Password")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        
        try row.set("UserID",    UserID)
        try row.set("UserUUID",  UserUUID)
        try row.set("FirstName", FirstName)
        try row.set("LastName",  LastName)
        try row.set("EMail",     EMail)
        try row.set("Password",  Password)
        
        return row
    }
}

extension Users: Preparation {
    // Creates table if one does not already exist. E.G. essentially initial schema migrations.
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            
            // the .suffix of each builder will coincide to the datatype of the model property,
            // the builder will best fit this to a type depending on the Database provider used.
            //builder.id()
            
            builder.int("UserID",       optional: false, unique: true)
            builder.string("UserUUID",  optional: false, unique: true)
            builder.string("FirstName", optional: false, unique: false)
            builder.string("LastName",  optional: false, unique: false)
            builder.string("EMail",     optional: false, unique: true)
            builder.string("Password",  optional: false, unique: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
