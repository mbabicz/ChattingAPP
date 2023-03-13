//
//  GlobalChat.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI

struct GlobalChatView: View {
    
    @State var typingMessage: String = ""
    @StateObject var messageVM = MessageViewModel()
    @Namespace var bottomID
    @State private var showSendButton = false
    @FocusState private var fieldIsFocused: Bool
    
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    @State private var showCameraLoader = false
    @State private var showImageButtons = true

    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                ScrollViewReader{ reader in
                    ScrollView {
                        ForEach(messageVM.messages?.sorted(by: { $0.sentDate < $1.sentDate }) ?? [], id: \.self) { message in
                            MessageView(message: message)
                                .id(message.id)

                        }
                        .padding(.vertical, -3)
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
                Divider()
                    .padding(.bottom, 10)
                
                HStack(alignment: .center) {
                    if showImageButtons && inputImage == nil{
                        Button(action: {
                            showCameraLoader = true
                        }) {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 10)
                        }
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 10)
                        }
                    } else if inputImage == nil {
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showImageButtons = true
                            }
                        }) {
                            Image(systemName: "greaterthan")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 20, height: 20)
                        }
                    }
                    if inputImage != nil {
                        HStack(alignment: .center) {
                            Image(uiImage: inputImage!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 140)
                                .padding(.vertical, 10)
                                .cornerRadius(10)
                                .overlay(
                                    HStack(alignment: .top){
                                        Spacer()
                                        VStack{
                                            Button(action: {
                                                withAnimation {
                                                    inputImage = nil
                                                }
                                            }, label: {
                                                Image(systemName: "xmark.circle")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.7))
                                                    .clipShape(Circle())
                                                    .padding(.top, 10)
                                            })
                                            Spacer()
                                        }
                                    })
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        .animation(.easeInOut(duration: 0.5))
                    } else {
                        TextField("Message...", text: $typingMessage)
                            .focused($fieldIsFocused)
                            .font(.callout)
                            .padding(10)
                            .lineLimit(3)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .background(Capsule().stroke(Color.gray, lineWidth: 1))
                            .frame(width: typingMessage.isEmpty ? UIScreen.main.bounds.width - 100 : nil, height: 40)
                            .animation(.easeOut(duration: 0.5))
                            .onTapGesture {
                                withAnimation {
                                    fieldIsFocused = true
                                }
                            }
                    }
                    
                    if !typingMessage.isEmpty || inputImage != nil{
                        Spacer()
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.2)) {
                                messageVM.sendMessage(message: typingMessage)
                                typingMessage = ""
                                showSendButton = false
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.green)
                                .frame(width: 25, height: 25)
                                .padding(.trailing)
                        }
                        .opacity(showSendButton ? 1 : (inputImage != nil ? 1 : 0))
                    }
                }
                .padding([.bottom, .leading], 10)
                .padding(.trailing, typingMessage.isEmpty ? 10 : 0)
                
                .onChange(of: typingMessage) { newValue in
                    withAnimation {
                        showSendButton = !newValue.isEmpty
                        showImageButtons = newValue.isEmpty
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
            .sheet(isPresented: $showImagePicker){
                ImagePicker(image: $inputImage)
                    .presentationDetents([.fraction(0.5)])
            }
            .sheet(isPresented: $showCameraLoader){
                CameraLoader(image: $inputImage)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct GlobalChat_Previews: PreviewProvider {
    static var previews: some View {
        GlobalChatView()
    }
}
