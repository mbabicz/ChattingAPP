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
                    ChatBotView().tabItem {
                        Image("bot")
                            .resizable()
                    }.tag(0)
                    
                    GlobalChatView().tabItem {
                        Image("global")
                        
                    }.tag(1)
                    
                }.accentColor(.green)
                
                ChatBotView()

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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
