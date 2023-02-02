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
    
    var body: some View {
        VStack{

            ScrollView(.vertical) {
                ScrollViewReader { reader in
                    ForEach(models, id: \.self) { message in
                        HStack {
                            if message.contains("Me: ") {
                                Spacer()
                                MessageView(
                                    message: message.replacingOccurrences(of: "Me: ", with: ""),
                                    isUserMessage: true,
                                    isLastMessage: true
                                )
                            } else {
                                MessageView(
                                    message: message,
                                    isUserMessage: false,
                                    isLastMessage: true
                                )
                                Spacer()
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }

            Divider()
            HStack {
                TextField("Message...", text: $typingMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                Button(action: send) {
                    Image(systemName: "arrowshape.turn.up.right.circle.fill")
                        .resizable()
                        .frame(width: 42, height: 42)
                        .padding(.trailing)
                        .foregroundColor(.green)
                }
            }
        }
        .onAppear {
            botVM.setup()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("ChatBot")
        
    }
    
    func send() {
        guard !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty,
            models.isEmpty || models.last != "Me: \(typingMessage)" else {
            return
        }
        models.append("Me: \(typingMessage)")
        botVM.send(text: typingMessage) { response in
            DispatchQueue.main.async {
                self.models.append("ChatBot: " + response)
                self.typingMessage = ""
            }
        }
    }


}


struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}

