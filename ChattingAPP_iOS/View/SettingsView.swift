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
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = userViewModel.user, let imageURL = user.imageURL {
                    if let image = image {
                        image
                            .resizable()
                            .padding(.top)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        
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
