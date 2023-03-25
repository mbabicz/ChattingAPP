//
//  ImageViewerView.swift
//  ChattingAPP
//
//  Created by kz on 24/03/2023.
//

import SwiftUI

struct ImageViewerView: View {
    var image: UIImage
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    @State var isDetectingLongPress = false
    @State var isDetectingPan = false
    @GestureState var isDetectingPinch = false

    var body: some View {
        let magnificationGesture = MagnificationGesture()
            .updating($isDetectingPinch) { currentState, gestureState, transaction in
                gestureState = true
            }
            .onChanged { scale in
                self.scale = self.lastScaleValue * scale
            }
            .onEnded { scale in
                let newScale = min(max(scale * self.lastScaleValue, 1), 5.0)
                self.scale = newScale
                self.lastScaleValue = newScale
            }


        let pinchToZoom = magnificationGesture.simultaneously(with: TapGesture(count: 2).onEnded({
            withAnimation {
                self.scale = 1.0
                self.lastScaleValue = 1.0
            }
        }))

        return Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(self.scale)
            .gesture(pinchToZoom)
            .animation(.easeInOut(duration: 0.2))

    }
}
