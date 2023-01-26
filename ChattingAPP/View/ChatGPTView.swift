//
//  ChatGPTView.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI

struct ChatGPTView: View {
    @ObservedObject var GptVM = GPTViewModel()
    @State var typingMessage: String = ""
    @State var models = [String]()
    
    var body: some View {
        NavigationView(){
            VStack{
                VStack(alignment: .leading){
                    ScrollView(.vertical){
                        ForEach(models, id: \.self) { string in
                            if string.contains("Me: "){
                                HStack{
                                    Spacer()
                                    var newString = string.replacingOccurrences(of: "Me: ", with: "")
                                    Text(newString).foregroundColor(.green)

                                }
                                .padding()
                            }
                            else {
                                HStack{
                                    Text(string)
                                    Spacer()
                                }

                            }
                            
                        }
                        .padding()
                    }
                }
                Spacer()
                Divider()
                HStack{
                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.right.circle.fill")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .padding(.trailing)
                            .foregroundColor(.green)
                        
                    }
                    
                }
            }
            .onAppear{
                GptVM.setup()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("ChatGPT")
            
        }
        

        

    }
    
    func send(){
        guard !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        models.append("Me: \(typingMessage)")
        GptVM.send(text: typingMessage){ response in
            DispatchQueue.main.async {
                self.models.append("ChatBot: "+response)
                self.typingMessage = ""
            }
        }
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView()
    }
}
