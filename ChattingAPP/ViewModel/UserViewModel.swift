//
//  UserViewModel.swift
//  ChattingAPP
//
//  Created by kz on 01/02/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import SwiftUI
import FirebaseStorage

class UserViewModel: ObservableObject {
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    @Published var user: User?
    
    //alerts
    @Published var showingAlert : Bool = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    
    var userID: String? {
        return auth.currentUser?.uid
    }
    
    var userIsAuthenticated: Bool {
        return auth.currentUser != nil
    }
    
    var userIsAuthenticatedAndSynced: Bool {
        return user != nil && userIsAuthenticated
    }
    
    func signUp(email: String, password: String, username: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertTitle = "Error"
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
            } else {
                DispatchQueue.main.async {
                    self.addUser(User(username: username, userEmail: email, pushNotifications: true, image: "https://firebasestorage.googleapis.com/v0/b/chattingapp-293de.appspot.com/o/profile_img.png?alt=media&token=95e18e55-d066-4fa6-9709-42b0b56841c1https://firebasestorage.googleapis.com/v0/b/chattingapp- 293de.appspot.com/o/profile_img.png?alt=media&token=95e18e55-d066-4fa6-9709-42b0b56841c1"))
                    self.syncUser()
                }
            }
        }
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password){ result, error in
            if let error = error {
                self.alertTitle = "Error"
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
            } else {
                DispatchQueue.main.async{
                    self.syncUser()
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        auth.sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.alertTitle = "Error"
                self.alertMessage = error.localizedDescription
            } else {
                self.alertTitle = "Success"
                self.alertMessage = "Password reset request sent to your email."
            }
            self.showingAlert = true
        }
    }

    
    func signOut(){
        do{
            try auth.signOut()
            self.user = nil
        }
        catch{
            print("Error signing out user: \(error)")
        }
    }
    
    //MARK: firestore functions for user data
    func syncUser(){
        guard userIsAuthenticated else { return }
        db.collection("Users").document(self.userID!).getDocument { document, error in
            guard document != nil, error == nil else { return }
            do{
                try self.user = document!.data(as: User.self)
            } catch{
                print("sync error: \(error)")
            }
        }
    }
    
    private func addUser(_ user: User){
        guard userIsAuthenticated else { return }
        do {
            let _ = try db.collection("Users").document(self.userID!).setData(from: user)

        } catch {
            print("Error adding: \(error)")
        }
        
    }
    
    func update(){
        guard userIsAuthenticatedAndSynced else { return }
        do{
            let _ = try db.collection("Users").document(self.userID!).setData(from: user)
        } catch{
            print("error updating \(error)")
        }
        
    }

    func getUserByUID(userID: String, completion: @escaping (User?) -> Void) {
        let ref = db.collection("Users").document(userID)
        ref.getDocument { snapshot, error in
            if let error = error {
                print("Error getting user from db: \(error)")
                completion(nil)
                return
            }
            guard let data = snapshot?.data(),
                  let username = data["username"] as? String,
                  let userEmail = data["userEmail"] as? String,
                  let image = data["image"] as? String
                    
            else {
                completion(nil)
                return
            }
            let user = User(username: username, userEmail: userEmail, image: image)
            completion(user)
        }
    }
    
    public func uploadUserImage(image: UIImage) {
        let storage = Storage.storage()
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
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
                let imageURLString = url.absoluteString
                self.user?.image = imageURLString
                self.update()
                self.alertTitle = "Succes"
                self.alertMessage = "Account updated succesfully"
                self.showingAlert = true
            }
        }
    }

}
