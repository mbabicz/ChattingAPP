//
//  SettingsView.swift
//  ChattingAPP
//
//  Created by kz on 02/02/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @State var notifactionsToggle: Bool = false
    @EnvironmentObject var user: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Spacer()
                    ProfilePictureView()
                    Spacer()
                }
                Divider()
                Toggle(
                    isOn: $notifactionsToggle,
                    label: {
                        Text("Push notifications")
                    })
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .padding()
                .background(
                    Color(.gray)
                        .opacity(0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                )
                .padding()
                Button {
                    user.user?.pushNotifications = notifactionsToggle
                    user.update()
                } label: {
                    Text("Save")
                        .frame(width: 200, height: 50)
                        .bold()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(45)
                        .padding()

                }
                Spacer()
            }
            Spacer()
        }
        .onAppear{
            notifactionsToggle = user.user!.pushNotifications!
        }
    }
}

struct ProfilePictureView: View {
    var body: some View {
        VStack{
            Image(systemName: "person.fill")
            Button {
                //
            } label: {
                Text("Change profile picture")
            }
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(notifactionsToggle: false)
    }
}
