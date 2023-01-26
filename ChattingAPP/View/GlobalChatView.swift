//
//  GlobalChat.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI

struct GlobalChatView: View {
    
    @State var typingMessage: String = ""
    
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                HStack{
                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: "arrowshape.turn.up.right.circle.fill")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .padding(.trailing)
                            .foregroundColor(.green)
                        
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Global chat")
        }
    }
}

struct GlobalChat_Previews: PreviewProvider {
    static var previews: some View {
        GlobalChatView()
    }
}
