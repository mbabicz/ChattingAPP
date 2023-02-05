//
//  ChatBotView.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI

struct ChatBotView: View {
    
    @ObservedObject var botVM = ChatBotViewModel()
    @State var typingMessage: String = ""
    @State var models = [String]()
    @Namespace var bottomID
    
    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                ScrollViewReader { reader in
                    ScrollView(.vertical) {
                        ForEach(models, id: \.self) { message in
                            HStack {
                                if message.contains("Me: ") {
                                    MessageView(message: message.replacingOccurrences(of: "Me: ", with: ""), isUserMessage: true, isBotMessage: false, isLastMessage: true)
                                } else if message.contains("ChatBot: ") {
                                    MessageView(message: message.replacingOccurrences(of: "ChatBot: ", with: "").trimmingCharacters(in: .whitespacesAndNewlines), isUserMessage: false, isBotMessage: true, isLastMessage: true)
                                } else {
                                    LoadingIndicatorView()
                                    Spacer()
                                }
                            }
                        }
                        Text("").id(bottomID)
                    }

                    .onAppear{
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                    .onChange(of: models.count){ _ in
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                }
                Divider()
                HStack(alignment: .top){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .padding(.leading)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Button {
                        send()
                        self.typingMessage = ""

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
            .navigationBarTitle("ChatBot")
        }
        .onAppear {
            botVM.setup()
        }
        
    }
    
    func send() {
        guard !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty,
            models.isEmpty || models.last != "Me: \(typingMessage)" else {
            return
        }

        models.append("Me: \(typingMessage)")
        models.append("Waiting:")

        botVM.send(text: typingMessage) { response in
            DispatchQueue.main.async {
                self.models.removeLast()
                self.models.append("ChatBot: \(response)")
            }
        }
    }
}

struct DotView: View {
    
    @State var scale: CGFloat = 0.5
    @State var delay: Double = 0
    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(Animation.easeInOut.repeatForever().delay(delay)) {
                    self.scale = 1
                }
            }
    }
}


struct LoadingIndicatorView: View {
    var body: some View {
        HStack {
            DotView()
            DotView(delay: 0.2)
            DotView(delay: 0.4)
        }
        .padding(16)
        .foregroundColor(.black)
        .background(Color.gray.opacity(0.25))
        .cornerRadius(25)
        .padding(.leading)
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}
