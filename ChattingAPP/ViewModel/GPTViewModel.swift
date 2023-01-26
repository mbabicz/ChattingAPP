//
//  GPTViewModel.swift
//  ChattingAPP
//
//  Created by kz on 26/01/2023.
//

import Foundation
import OpenAISwift


class GPTViewModel: ObservableObject{
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Api-keys", ofType: "plist") else {
                fatalError("Couldn't find Api-keys.plist file")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value  = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find api key")
                
            }
            return value
        }
    }
    
    private var client: OpenAISwift?
    
    func setup(){
        client = OpenAISwift(authToken: self.apiKey)
        
    }
    
    func send(text: String, completion: @escaping (String) -> Void){
        
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""

                completion(output)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })

    }

    
    
}

