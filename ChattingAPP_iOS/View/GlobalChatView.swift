//
//  GlobalChat.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI
import Introspect

struct GlobalChatView: View {
    
    @StateObject var messageVM = MessageViewModel()
    @State var typingMessage: String = ""
    @Namespace var bottomID
    @State private var showSendButton = false
    @FocusState private var fieldIsFocused: Bool
    
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    @State private var showCameraLoader = false
    @State private var showImageButtons = true
    @State private var showScrollButton = false

    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                ZStack(alignment: .bottom){
                    ScrollViewReader{ reader in
                        ScrollView {
                            ForEach(messageVM.messages?.sorted(by: { $0.sentDate < $1.sentDate }) ?? [], id: \.self) { message in
                                MessageView(message: message)
                                    .id(message.id)
                            }
                            .padding(.vertical, -3)
                            Text("").id(bottomID)
                        }
                        .onChange(of: messageVM.messages){ _ in
                            withAnimation{
                                reader.scrollTo(bottomID)
                            }
                        }
                        .onChange(of: fieldIsFocused){ _ in
                            withAnimation{
                                reader.scrollTo(bottomID)
                            }
                        }
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation{
                                    reader.scrollTo(bottomID)
                                }
                            }
                        }
                    }
                    if showScrollButton{
                        Button {
                            withAnimation{
                                //shouldScroll = true
                            }
                        } label: {
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .background(.white.opacity(0.5))
                                .foregroundColor(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 20)
                    }
                }
                Divider()
                    .padding(.bottom, inputImage != nil ? 10 : 0)
                
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
                                .padding(.horizontal, 10)
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
                            withAnimation {
                                showImageButtons = true
                            }
                        }) {
                            Image(systemName: "greaterthan")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 10)
                        }
                        .opacity(showImageButtons ? 0 : 1)
                        .animation(.easeInOut(duration: 0.2))
                        .onChange(of: typingMessage) { newValue in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showImageButtons = newValue.isEmpty
                            }
                        }
                    }
                    
                    if inputImage != nil {
                        HStack(alignment: .top){
                            Image(uiImage: inputImage!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 140)
                                .padding([.top, .leading, .bottom], 10)
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
                            
                            TextField("Message...", text: $typingMessage, axis: .vertical)
                                .focused($fieldIsFocused)
                                .font(.callout)
                                .padding(10)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .border(.red)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                    } else {
                        TextField("Message...", text: $typingMessage, axis: .vertical)
                            .focused($fieldIsFocused)
                            .textFieldStyle(.plain)
                            .font(.callout)
                            .padding(10)
                            .lineLimit(3)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .background(Capsule().stroke(Color.gray, lineWidth: 1))
                            .frame(width: !typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? UIScreen.main.bounds.width - 100 : nil)
                            .animation(.easeInOut(duration: 0.2), value: typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .onTapGesture {
                                fieldIsFocused = true
                            }
                    }
                    
                    if !typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || inputImage != nil{
                        Spacer()
                        Button(action: {
                            withAnimation{
                                let trimmedMessage = typingMessage.trimmingCharacters(in: .whitespaces)
                                messageVM.sendMessage(message: trimmedMessage, image: inputImage)
                                typingMessage = ""
                                inputImage = nil
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
                .padding(.bottom, 20)
                .padding(.top, 10)

                .padding(.trailing, typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 10 : 0)
                
                .onChange(of: typingMessage) { newValue in
                    withAnimation(.easeInOut) {
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
