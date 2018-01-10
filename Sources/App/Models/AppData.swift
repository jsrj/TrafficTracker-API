//
//  AppData.swift
//  tracker-api
//
//  Created by Arjay Jones on 1/10/18.
//
import Foundation
import FluentProvider

final class AppData: Model {
    // Must be named storage in order to conform to Storable Protocol
    let storage = Storage()
    
    // Properties <> Virtual Columns
    let AppCode:  Int
    let AppName:  String
    let OwnerID:  Int
    let OwnerKey: String
    
    // Initializer
    init(appName: String, ownerID: Int) {
        func generateAppCode() -> Int {
            let appCode  = arc4random_uniform(UInt32(999999))
            var randCode = String(appCode)
            var appendZero = ""
            if (randCode.count < 6) {
                var i = randCode.count
                while i < 6 {
                    appendZero += "0"
                    i += 1
                }
                randCode = String(appCode) + appendZero
            }
            return Int(randCode)!
        }
    
        func generatePHOwnerKey() -> String {
            // Generates a psuedo-hexadecimal key for app owners to access the API on a per-app basis.
            var ownerKey: String = ""
            let hexaDict: [Int: String] = [
            0: "0", 1: "1", 2: "2", 3: "3", 4: "4", 5: "5", 6: "6", 7: "7",
            8: "8", 9: "9", 10: "A", 11: "B", 12: "C", 13: "D", 14: "E", 15: "F"
            ]
            while ownerKey.count < hexaDict.count {
                ownerKey += hexaDict[Int(arc4random_uniform(16))]!
            }
            return ownerKey
        }
    
        self.AppCode  = generateAppCode()
        self.AppName  = appName
        self.OwnerID  = ownerID
        self.OwnerKey = generatePHOwnerKey()
    }
    
    // Storable Protocol Specifics
    // Database <-> Swift conversion of rows(relational) and properties(non-relational)
    init(row: Row) throws {
        // populate each property based on a row value retrieved from DB. Takes place of standard initializer.
        AppCode  = try row.get("AppCode")
        AppName  = try row.get("AppName")
        OwnerID  = try row.get("OwnerID")
        OwnerKey = try row.get("OwnerKey")
    }
    
    func makeRow() throws -> Row {
        var row = Row() /* <- Can be assigned the same way as in JSON() */
        
        // Set a column to  the row for each property of the model.
        try row.set("AppCode",  AppCode)
        try row.set("AppName",  AppName)
        try row.set("OwnerID",  OwnerID)
        try row.set("OwnerKey", OwnerKey)
        
        return row
    }
}

extension AppData: Preparation {
    // Creates table if one does not already exist. E.G. essentially initial schema migrations.
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            
            // the .suffix of each builder will coincide to the datatype of the model property,
            // the builder will best fit this to a type depending on the Database provider used.
            //builder.id()
            
            // Every app has a code, and each code must be unique.
            builder.int("AppCode",    optional: false, unique: true)
            // Every app has a name, but may not share a name with another app.
            builder.string("AppName", optional: false, unique: true)
            // Every app has an owner, but multiple apps can have the same owner.
            builder.string("OwnerId", optional: false, unique: false)
            // Every app has a specific key code to ensure only the owner of the app can access data for it on the API.
            builder.string("OwnerKey", optional: false, unique: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
