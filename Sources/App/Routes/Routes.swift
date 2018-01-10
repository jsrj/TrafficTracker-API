import Vapor
import JSON

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
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
        get("info") { req in
            return req.description
        }

        //get("description") { req in return req.description }
        
        //try resource("posts", PostController.self)
    }
}
