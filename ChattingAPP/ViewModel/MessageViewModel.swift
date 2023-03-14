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
    
    func sendMessage(message: String, image: UIImage?) {
        //upload picture
        let storage = Storage.storage()
        var imageURL = String()
        if image != nil {
            guard let imageData = image!.jpegData(compressionQuality: 0.5) else { return }
            let imgReference = storage.reference().child("\(userID!).jpeg")
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
//                    self.user?.image = imageURLString
//                    self.update()
//                    self.alertTitle = "Succes"
//                    self.alertMessage = "Account updated succesfully"
//                    self.showingAlert = true
                }
            }
            
        }

        
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("Messages").document()
        
        ref.setData([
            "date": Timestamp(date: Date()),
            "message": message,
            "userID": userID
        ]) { error in
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
                    let message = doc["message"] as? String ?? ""
                    let userID = doc["userID"] as? String ?? ""
                    
                    return Message(id: id, userID: userID, sentDate: date, message: message)
                }
            }
        }
    }
}
