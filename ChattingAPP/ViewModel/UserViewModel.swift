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
    
    func signUp(email: String, password: String, username: String){
        auth.createUser(withEmail: email, password: password){ (result, error) in
            if error != nil{
                self.alertTitle = "Error"
                self.alertMessage = error?.localizedDescription ?? "Something went wrong"
                self.showingAlert = true
            } else {
                DispatchQueue.main.async{
                    self.addUser(User(username: username, userEmail: email, pushNotifications: true))
                    self.syncUser()
                }
            }
        }
    }
    
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password){ (result, error) in
            if error != nil{
                self.alertTitle = "Error"
                self.alertMessage = error?.localizedDescription ?? "Something went wrong"
                self.showingAlert = true
            } else {
                DispatchQueue.main.async{
                    //Success
                    self.syncUser()

                }
            }
        }
    }
    
    
    func resetPassword(email: String){
        auth.sendPasswordReset(withEmail: email) { error in
            if error != nil{
                self.alertTitle = "Error"
                self.alertMessage = error?.localizedDescription ?? "Coś poszło nie tak!"
                self.showingAlert = true
            } else {
                self.alertTitle = "Succes"
                self.alertMessage = "Prośba o zmiane hasła została wysłana na twój adres email.."
                self.showingAlert = true
            }
            
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
                  let userEmail = data["userEmail"] as? String
            else {
                completion(nil)
                return
            }

            let user = User(username: username, userEmail: userEmail)
            completion(user)
        }
    }

    
//    private func changeNotificationsSettings(){
//
//    }
}
