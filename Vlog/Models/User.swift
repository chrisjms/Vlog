//
//  User.swift
//  Vlog
//
//  Created by Christopher James on 26/09/2022.
//

import Foundation

struct User {
    
    enum profile: String {
        case admin = "ADMIN"
        case subscriber = "SUBSCRIBER"
    }
    
    var lastName: String = ""
    var firstName: String = ""
    var mail: String = ""
    var password: String = ""
    var isConnected: Bool = false
    var profile: profile = .subscriber
    
}
