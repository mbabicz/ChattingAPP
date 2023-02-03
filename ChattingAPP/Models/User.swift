//
//  User.swift
//  ChattingAPP
//
//  Created by kz on 31/01/2023.
//

import Foundation

struct User: Codable {
    
    var username: String
    var signUpDate = Date.now
    var userEmail: String
    var pushNotifications: Bool?
    
}
