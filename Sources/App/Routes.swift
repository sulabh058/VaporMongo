import Vapor
import MongoProvider

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

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        get("user") { req in
            
            let json = try Userlist.makeQuery().all().makeJSON()
            return json

     
        }
        
        post("user", "new") { (request) -> ResponseRepresentable in
            guard let userName = request.data["username"]?.string,
                let email = request.data["email"]?.string else {
                    throw Abort.badRequest
            }
            
            let user = Userlist(userName: userName, email: email)
            try user.save()
            
            return "Success!\n\nUser Info:\nName: \(user.userName)\nEmail: \(user.email)\nID: \(String(describing: user.id?.wrapped))"
        }

        
        try resource("posts", PostController.self)
    }
}
