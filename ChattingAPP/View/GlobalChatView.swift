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
                            MessageView(message: message.message, isUserMessage: message.userID == user.userID, isBotMessage: false, isLastMessage: isLastMessage(for: message) ,userID: message.userID)
                                .id(message.id)
                        }
                        Text("").id(bottomID)
                    }
                    
                    .onAppear{
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                    .onChange(of: messageVM.messages?.count){ _ in
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                }

                Spacer()
                Divider()
                HStack(alignment: .top){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .padding(.leading)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5)
                    
                    Button {
                        if (typingMessage != ""){
                            messageVM.sendMessage(message: typingMessage)
                            typingMessage = ""
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .padding(.trailing)
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(45))
                            .font(.system(size: 36))
                    }
                }
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Global chat")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        user.signOut()
                    } label: {
                        Text("Log out")
                            .font(.headline)
                            .foregroundColor(.green)
  
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.green)

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
