//
//  MessageViewModel.swift
//  ChattingAPP
//
//  Created by kz on 01/02/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


class MessageViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var messages: [Message]?
    
    var userID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func sendMessage(message: String?, image: UIImage?) {
        //upload picture
        let storage = Storage.storage()
        var imageURL: String?
        
        if let image = image {

            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            let imgReference = storage.reference().child(userID!).child(UUID().uuidString + ".jpeg")
            imgReference.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                print("Image uploaded successfully")
                imgReference.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let url = url else { return }
                    imageURL = url.absoluteString
                    self.saveMessageToDatabase(message: message, imageURL: imageURL)

                }
            }
        } else {
            self.saveMessageToDatabase(message: message, imageURL: nil)
        }
    }
    
    func saveMessageToDatabase(message: String?, imageURL: String?) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("Messages").document()
            
        var data: [String: Any] = [
            "date": Timestamp(date: Date()),
            "userID": userID
        ]

        if let message = message {
            data["message"] = message
        }
        if let imageURL = imageURL {
            data["imageURL"] = imageURL
        }
            
        ref.setData(data) { error in
            if let error = error {
                print("Error sending message to db: \(error.localizedDescription)")
            }
        }
    }
    
    func getMessages() {
        let ref = db.collection("Messages")
        
        ref.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let snapshot = querySnapshot, error == nil {
                self.messages = snapshot.documents.compactMap { doc -> Message? in
                    let id = doc.documentID
                    let date = (doc["date"] as? Timestamp)?.dateValue() ?? Date()
                    let message = doc["message"] as? String
                    let imageURL = doc["imageURL"] as? String

                    let userID = doc["userID"] as? String ?? ""
                    
                    switch (doc["message"], doc["imageURL"]) {
                     case let (message as String, imageURL as String):
                         return Message(id: id, userID: userID, sentDate: date, message: message, imageURL: imageURL)
                     case let (message as String, nil):
                         return Message(id: id, userID: userID, sentDate: date, message: message)
                     case let (nil, imageURL as String):
                         return Message(id: id, userID: userID, sentDate: date, imageURL: imageURL)
                     default:
                         return nil
                     }
                }
            }
        }
    }
}
