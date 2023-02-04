//
//  MessageView.swift
//  ChattingAPP
//
//  Created by kz on 02/02/2023.
//

import SwiftUI

struct MessageView: View {
    @EnvironmentObject var user: UserViewModel
    var message: String
    var isUserMessage: Bool
    var isLastMessage: Bool
    var userID: String?
    @State private var sentBy: User?
    
    var body: some View {
        HStack(spacing: 0) {
            if isUserMessage {
                Spacer()
            }
            HStack(alignment: .top, spacing: 0){
                if !isUserMessage, let sentBy = sentBy {
                    ProfileImageView(imageURL: sentBy.imageURL, width: 30, height: 30)
                        .padding(.top, 20)
                        .padding(.trailing, 5)
                }
                VStack(alignment: .leading,spacing: 0){
                    if !isUserMessage, let sentBy = sentBy {
                        Text(sentBy.username)
                            .font(.footnote)
                            .foregroundColor(.black.opacity(0.5))
                            .padding(.leading, 10)
                        
                    }
                    Text(message)
                        .padding(10)
                        .font(.callout)
                        .foregroundColor(isUserMessage ? .white : .black)
                        .background(isUserMessage ? Color.green : Color.gray.opacity(0.25))
                        .cornerRadius(25)
                    
                    
                }
            }

            if !isUserMessage {
                Spacer()
            }

        }
        .padding(.leading, 10)
        .padding(.trailing, 10)

        .onAppear{
            if let userID = userID{
                user.getUserByUID(userID: userID) { user in
                    self.sentBy = user
                }
            }
        }
        
    }


}
