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
    
    @State private var showSendButton = false
    @State private var hasMessage = false
    
    @FocusState private var fieldIsFocused: Bool

    
    var body: some View {
        VStack{
            ScrollViewReader{ reader in
                ScrollView {
                    ForEach(messageVM.messages?.sorted(by: { $0.sentDate < $1.sentDate }) ?? [], id: \.self) { message in
                        MessageView(message: message.message, isUserMessage: message.userID == user.userID, isLastMessage: isLastMessage(for: message) ,userID: message.userID)
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
            
            HStack(alignment: .center) {
                TextField("Message...", text: $typingMessage)
                    .focused($fieldIsFocused)
                    .font(.callout)
                    .padding(10)
                    .lineLimit(3)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .background(Capsule().stroke(Color.gray, lineWidth: 1))
                    .frame(width: typingMessage.isEmpty ? UIScreen.main.bounds.width - 25 : nil, height: 40)
                    .animation(.easeOut(duration: 0.2))
                    .onTapGesture {
                        fieldIsFocused = true
                    }

                if !typingMessage.isEmpty {
                    Spacer()
                    Button(action: {
                        messageVM.sendMessage(message: typingMessage)
                        typingMessage = ""
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.green)
                            .frame(width: 30, height: 30)
                            .padding(.trailing)
                    }
                    .opacity(showSendButton ? 1 : 0)
                    .animation(.easeOut(duration: 0.2).delay(0.2))
                }
            }
            .padding(.bottom, 10)          

            .onChange(of: typingMessage) { newValue in
                withAnimation {
                    showSendButton = !newValue.isEmpty
                }
            }
            
            .onDisappear {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Global chat")
        .onAppear{
            messageVM.getMessages()
        }
        .gesture(TapGesture().onEnded {
            hideKeyboard()
        })
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
