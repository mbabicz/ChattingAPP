//
//  Message.swift
//  ChattingAPP
//
//  Created by kz on 01/02/2023.
//

import Foundation

//enum MessageType {
//    case text
//    case image
//    case indicator
//}

struct Message: Codable, Hashable {
    
    var id: String
    var userID: String
    var sentDate: Date
    var message: String?
    var imageURL: String?
    
}
