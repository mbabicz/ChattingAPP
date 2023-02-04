//
//  ProfileImageView.swift
//  ChattingAPP
//
//  Created by kz on 04/02/2023.
//

import SwiftUI

struct ProfileImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(width: self.width, height: self.height, alignment: .center)
                .cornerRadius(12)
                .overlay(
                    ZStack {
                        ProgressView()
                        if imageLoader.image != nil {
                            HStack {
                                Spacer()
                                Image(uiImage: imageLoader.image!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                Spacer()
                            }
                        }
                    }
                )
        }
        .onAppear {
            imageLoader.loadImage(with: imageURL)
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(imageURL: URL(string:"")!, width: 100, height: 100)
    }
}
