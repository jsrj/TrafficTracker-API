//
//  AppData.swift
//  tracker-apiPackageDescription
//
//  Created by Arjay Jones on 1/10/18.
//

import Foundation

final class AppData {
    
    // Properties
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
}
