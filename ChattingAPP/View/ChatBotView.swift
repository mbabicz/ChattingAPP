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
            VStack{
                ScrollViewReader { reader in
                    ScrollView(.vertical) {
                        
                        ForEach(models, id: \.self) { message in
                            HStack {
                                Spacer(minLength: message.contains("Me: ") ? 0 : 20)
                                MessageView(
                                    message: message.contains("Me: ") ? message.replacingOccurrences(of: "Me: ", with: "") : message,
                                    isUserMessage: message.contains("Me: "),
                                    isLastMessage: true
                                )
                                Spacer(minLength: message.contains("Me: ") ? 20 : 0)
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
                HStack {
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5)
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

