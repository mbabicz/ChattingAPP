//
//  ImageViewerView.swift
//  ChattingAPP
//
//  Created by kz on 24/03/2023.
//

import SwiftUI

struct ImageViewerView: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }
}
