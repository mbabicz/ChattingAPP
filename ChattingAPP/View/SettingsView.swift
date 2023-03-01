//
//  SettingsView.swift
//  ChattingAPP
//
//  Created by kz on 02/02/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = userViewModel.user, let imageURL = user.imageURL {
                    if let image = image {
                        image
                            .resizable()
                            .frame(height: 150)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(.top)
                    } else {
                        ProfileImageView(imageURL: imageURL, width: 150, height: 150)
                            .padding(.top)
                    }
                }
                
                Button {
                    showImagePicker = true
                } label: {
                    Text("Upload image")
                }
                
                Button {
                    if image != nil {
                        userViewModel.uploadUserImage(image: self.inputImage!)
                    }
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Settings")
            
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button {
                                userViewModel.signOut()
                            } label: {
                                Text("Log out")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                        }

                    }
        }

//            VStack{
//                HStack{
//                    Spacer()
//                    if let user = user.user {
//                        if let image = image {
//                            image
//                                .resizable()
//                                .frame(height: 150)
//                                .aspectRatio(contentMode: .fit)
//                                .clipShape(Circle())
//                        } else {
//                            ProfileImageView(imageURL: user.imageURL, width: 150, height: 150)
//                        }
//                    }
//                    Spacer()
//                }
//                Button {
//                    showImagePicker = true
//                } label: {
//                    Text("Upload image")
//                }
//
//                Divider()
//                Toggle(
//                    "Push notifications",
//                    isOn: $notifactionsToggle
//                )
//                .toggleStyle(SwitchToggleStyle(tint: .green))
//                .padding()
//                .background(
//                    Color(.gray)
//                        .opacity(0.25)
//                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//                )
//                .padding()
//                Button {
//                    user.user?.pushNotifications = notifactionsToggle
//                    if image != nil {
//                        user.uploadUserImage(image: self.inputImage!)
//                    }
//                    user.update()
//                } label: {
//                    Text("Save")
//                        .frame(width: 200, height: 50)
//                        .bold()
//                        .foregroundColor(.white)
//                        .background(Color.green)
//                        .cornerRadius(45)
//                        .padding()
//
//                }
//                Spacer()
//            }
//            Spacer()
//
//
//        }
////        .navigationBarTitleDisplayMode(.inline)
////        .navigationBarTitle("ChatBot")
//
//        .toolbar{
//            ToolbarItem(placement: .navigationBarTrailing){
//                Button {
//                    user.signOut()
//                } label: {
//                    Text("Log out")
//                        .font(.headline)
//                        .foregroundColor(.green)
//                }
//            }

        //}

//        .onAppear{
//            notifactionsToggle = userViewModel.user!.pushNotifications ?? true
//        }
        .sheet(isPresented: $showImagePicker){
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
        
    }
    
    func loadImage() {
        guard inputImage != nil else { return }
        image = Image(uiImage: inputImage!)
    }
}
    
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
