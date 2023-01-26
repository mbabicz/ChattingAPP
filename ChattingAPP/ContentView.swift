//
//  ContentView.swift
//  ChattingAPP
//
//  Created by kz on ww25/01/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            TabView{
                ChatGPTView().tabItem {
                    Image("bot")
                        .resizable()
                }.tag(0)
                
                GlobalChatView().tabItem {
                    Image("global")
                    
                }.tag(1)
                
            }.accentColor(.green)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
