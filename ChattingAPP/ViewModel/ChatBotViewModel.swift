//
//  ChatBotViewModel.swift
//  ChattingAPP
//
//  Created by kz on 26/01/2023.
//

import Foundation
import OpenAISwift

class ChatBotViewModel: ObservableObject{
    
    var isWaitingForResponse: Bool = false
    
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Api-keys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist["API_KEY"] as? String
        else {
            fatalError("Couldn't find api key in Api-keys.plist")
        }
        return value
    }
    
    private var client: OpenAISwift?
    
    init() {
        setup()
    }
    
    func setup(){
        client = OpenAISwift(authToken: apiKey)
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        self.isWaitingForResponse = true
        print(self.isWaitingForResponse)

        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
                self!.isWaitingForResponse = false
                print(self!.isWaitingForResponse)

            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

}
