import Vapor
import JSON
import Foundation
import BCrypt

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        // In order for a user to successfully talk to the tracker API from their application, the app needs to send the owner key,
        // and userID as ownerID as well as the user's password.
        get("dummy") { req in
            let app = AppData(appName: "Dummy App", ownerID: 253846)
            var json = JSON()
            try json.set("AppCode",  app.AppCode)
            try json.set("AppName",  app.AppName)
            try json.set("OwnerID",  app.OwnerID)
            try json.set("OwnerKey", app.OwnerKey)
            return json
        }

        // response to requests to /info domain
        // with a description of the request
        //        get("info") { req in
        //            return req.description
        //        }
        
        post("user/new") { req in
            var response = JSON()
            var userJson = JSON()
            var validFields: [Bool] = []
            var content = req.data
            
            func generateUserID() -> Int {
                var UID: Int
                UID = Int(arc4random_uniform(UInt32(9999999)))
                // To ensure that userID does not exist, validate by query and only allow if none already exist e.g. SQL Query returns none.
                // if Users.Find(UserID: UID) == nil {
                return UID
                // } else {
                // generateUID()
                // }
            }
            
            
            func generateUniqueUUID() -> String {
                let uuid = NSUUID().uuidString.lowercased()
                // if Users.Find(UserID: uuid) == nil {
                return uuid
                // } else {
                // generateUniqueUUID()
                // }
            }
            
            
            func backhashPassword(pw: String) -> String {
                var    bhpw: String = ""
                if (pw == "unspecified") {
                    bhpw = "unspecified"
                }
                do {
                    let digest = try BCrypt.Hash.make(message: pw)
                    bhpw = digest.base64Encoded.makeString()
                } catch {
                    print("An Unknown error occured.")
                }
                return bhpw
            }
            
            
            func ValidateStringField(field: String, resultList: inout [Bool]) -> String {
                let isValid = field == "unspecified" ? false : true
                resultList.append(isValid)
                return field
            }
            // TODO: Instead of using a nested ternary operator repeatedly, incorporate it into the validateStringField function.
            // Pass in the field from content, check if it is nil, check if it conforms to the parameters passed into a FieldType parameter,
            // if it is valid, then return the value passed in, otherwise return "unspecified"
            
            
            let newUser = Users(
                userID:    generateUserID(),
                userUUID:  generateUniqueUUID(),
                firstName: ValidateStringField(field: content["FirstName"]!.isNull ? "unspecified" : content["FirstName"]!.string!, resultList: &validFields),
                lastName:  ValidateStringField(field: content["LastName"]!.isNull  ? "unspecified" : content["LastName"]!.string!,  resultList: &validFields),
                email:     ValidateStringField(field: content["EMail"]!.isNull     ? "unspecified" : content["EMail"]!.string!,     resultList: &validFields),
                password:  ValidateStringField(field: backhashPassword(pw: content["Password"]!.isNull ? "unspecified" : content["Password"]!.string!), resultList: &validFields)
            )
            
            try userJson.set("UserID",    newUser.UserID)
            try userJson.set("UserUUID",  newUser.UserUUID)
            try userJson.set("FirstName", newUser.FirstName)
            try userJson.set("LastName",  newUser.LastName)
            try userJson.set("EMail",     newUser.EMail)
            try userJson.set("Password",  newUser.Password)
            
            // Iterate through validation results array, if all are true, then add newUser to DB and return a Status 200 with a JSONified newUser.
            var allFieldsValid: Bool = false
            for fieldIsValid in validFields {
                if (!fieldIsValid) {
                    allFieldsValid = false
                    break
                } else {
                    allFieldsValid = true
                }
            }
            
            if (allFieldsValid) {
                try response.set("message", "New User Created!")
                try response.set("User", userJson)
                return response
            } else {
                // Else return an Error Status with an Error Message.
                try response.set("message", "Error: One or more fields were not filled, or were filled incorrectly.")
                return response
            }
        }

        //get("description") { req in return req.description }
        //try resource("posts", PostController.self)
    }
}
