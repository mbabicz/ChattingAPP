//
//  ChattingAPPApp.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI
import Firebase

@main
struct ChattingAPPApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            let user = UserViewModel()
            let message = MessageViewModel()

            ContentView()
                .environmentObject(message)
                .environmentObject(user)

        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
