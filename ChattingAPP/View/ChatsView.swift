//
//  ChatsView.swift
//  ChattingAPP
//
//  Created by kz on 06/02/2023.
//

import SwiftUI

struct ChatsView: View {
    @EnvironmentObject var user: UserViewModel

    var body: some View {
        NavigationView{
            ScrollView{
                NavigationLink(destination: GlobalChatView()){
                    MessageBox()
                }
            }
        }
    }
}

struct MessageBox: View {    
    var body: some View {
        VStack(alignment: .leading){
            Text("Global chat")
                .padding()
            Divider()
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}


