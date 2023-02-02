//
//  GlobalChat.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI

struct GlobalChatView: View {
    
    @State var typingMessage: String = ""
    @EnvironmentObject var user: UserViewModel
    @StateObject var messageVM = MessageViewModel()
    @Namespace var bottomID

    
    var body: some View {
        NavigationView(){
            VStack{
                ScrollViewReader{ reader in
                    
                    ScrollView {
                        ForEach(messageVM.messages?.sorted(by: { $0.sentDate < $1.sentDate }) ?? [], id: \.self) { message in
                            MessageView(message: message.message, isUserMessage: message.userID == user.userID, isLastMessage: isLastMessage(for: message))
                                .id(message.id)
                        }
                        Text("").id(bottomID)
                    }
                    
                    .onAppear{
                        reader.scrollTo(bottomID)
                    }
                    .onChange(of: messageVM.messages?.count){ _ in
                        reader.scrollTo(bottomID)
                    }
                    
                }
                

                Spacer()
                Divider()
                HStack{
                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button {
                        if (typingMessage != ""){
                            messageVM.sendMessage(message: typingMessage)
                            typingMessage = ""
                        }
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
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        user.signOut()
                    } label: {
                        Text("Wyloguj się").font(.headline).foregroundColor(.green)
  
                    }
                    
                }
            }
            .onAppear{
                messageVM.getMessages()
            }
        }
    }
    private func isLastMessage(for message: Message) -> Bool {
        guard let messages = messageVM.messages else { return true }
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return true }
        return index == messages.count - 1
    }
}


struct GlobalChat_Previews: PreviewProvider {
    static var previews: some View {
        GlobalChatView()
    }
}
