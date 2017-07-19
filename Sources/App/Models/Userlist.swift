//
//  Userlist.swift
//  VaporMongo
//
//  Created by Sulabh Surendran on 7/18/17.
//
//
import FluentProvider
import Foundation

final class Userlist: Model {
    let storage = Storage()
    let userName: String
    let email: String
    
    init(userName: String, email: String) {
        self.userName = userName
        self.email = email
    }
    
    init(row: Row) throws {
        self.userName = try row.get("username")
        self.email = try row.get("email")
    }
}

extension Userlist: RowRepresentable {
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("username", userName)
        try row.set("email", email)
        return row
    }
}

extension Userlist: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id?.string)
        try json.set("username", userName)
        try json.set("email", email)
        return json
    }
}

extension Userlist: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("username")
             builder.string("email")
        }

    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

