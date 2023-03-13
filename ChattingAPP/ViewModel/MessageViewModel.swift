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

class MessageViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var messages: [Message]?
    
    func sendMessage(message: String) {
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
