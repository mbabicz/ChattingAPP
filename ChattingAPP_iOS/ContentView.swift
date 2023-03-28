//
//  ContentView.swift
//  ChattingAPP
//
//  Created by kz on ww25/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var user: UserViewModel

    var body: some View {
        NavigationView{
            if user.userIsAuthenticated && !user.userIsAuthenticatedAndSynced {
                VStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black)).frame(alignment: .center).scaleEffect(3).padding()
                    Button {
                        user.signOut()
                    } label: {
                        Text("logout")
                    }
                }
            }
            else if user.userIsAuthenticatedAndSynced{
                
                TabView{
                    GlobalChatView().tabItem {
                        Image(systemName: "text.bubble")
                    }.tag(0)
                    SettingsView().tabItem {
                        Image(systemName: "person")
                    }.tag(1)
                    
                }.accentColor(.green)
            }
            else{
                AuthenticationView()
            }
        }
        .onAppear{
            if user.userIsAuthenticated{
                user.syncUser()
            }
        }
        .gesture(TapGesture().onEnded {
            hideKeyboard()
        })

    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension UIWindow {
    func topMostViewController() -> UIViewController? {
        var topController = rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
