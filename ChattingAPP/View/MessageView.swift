//
//  MessageView.swift
//  ChattingAPP
//
//  Created by kz on 02/02/2023.
//

import SwiftUI

struct MessageView: View {
    @EnvironmentObject var user: UserViewModel
    var message: Message
    @State private var sentBy: User?
    @Environment(\.colorScheme) var colorScheme
    @State private var isUserMessage: Bool = false

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
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                    }
                    Text(message.message)
                        .padding(10)
                        .font(.callout)
                        .foregroundColor(isUserMessage ? .white : (colorScheme == .dark ? .white : .black))
                        .background(isUserMessage ? Color.green : Color.gray.opacity(0.25))
                        .cornerRadius(25)
                }
            }
            .padding(.trailing, 10)
            if !isUserMessage {
                Spacer()
            }
        }
        .onAppear{
            let userID = message.userID
                user.getUserByUID(userID: userID) { user in
                    self.sentBy = user
                }
            isUserMessage = user.userID == userID
        }
    }
}
