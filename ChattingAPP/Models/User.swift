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
    var image: String
//    = "https://firebasestorage.googleapis.com/v0/b/chattingapp-293de.appspot.com/o/profile_img.png?alt=media&token=95e18e55-d066-4fa6-9709-42b0b56841c1https://firebasestorage.googleapis.com/v0/b/chattingapp-293de.appspot.com/o/profile_img.png?alt=media&token=95e18e55-d066-4fa6-9709-42b0b56841c1"
    
    
}

extension User{
    var imageURL: URL {
        URL(string: image)!
    }
}
