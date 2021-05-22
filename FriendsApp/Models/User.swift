//
//  User.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 21/5/21.
//

import Foundation

struct User: Decodable {
    var name: Name?
    var location: Address?
    var email: String?
    var cell: String?
    var picture: Picture?
}

struct Name: Decodable {
    var title: String?
    var first: String?
    var last: String?
    
    func getFullName() -> String {
        return (title ?? "") + " " + (first ?? "") + " " + (last ?? "")
    }
}

struct Address: Decodable {
    var street: Street?
    var city: String?
    var state: String?
    var country: String?
    
    func getStreetAddress() -> String {
        var address = ""
        if let number = street?.number { address += "\(number), " }
        address += street?.name ?? ""
        return address
    }
    // this is a concated string of city, state and country
    func getStateAddress() -> String {
        var address = ""
        if let city = city { address += (city + ", ")}
        if let state = state { address += (state + ", ")}
        if let country = country { address += country}
        return address
    }
}

struct Street: Decodable {
    var number: Int?
    var name: String?
}

struct Picture: Decodable {
    var large: String?
    var medium: String?
}

// Data will be loaded as an array of user models
// to map it we will use another struct

struct Users: Decodable {
    var results: [User]?
}
