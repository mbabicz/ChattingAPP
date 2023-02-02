//
//  MessageView.swift
//  ChattingAPP
//
//  Created by kz on 02/02/2023.
//

import SwiftUI

struct MessageView: View {
    var message: String
    var isUserMessage: Bool
    var isLastMessage: Bool

    
    var body: some View {
        HStack {
            if isUserMessage {
                Spacer()
            }
            Text(message)
                .padding(10)
                .foregroundColor(isUserMessage ? .white : .black)
                .background(isUserMessage ? Color.blue : Color.gray.opacity(0.25))
                .cornerRadius(25)
            if !isUserMessage {
                Spacer()
            }
        }
        .padding(.top, isLastMessage ? 10 : 0)
        .padding(.leading, 10)
        .padding(.trailing, 10)


        
    }

}
