//
//  ImageCropView.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 26/04/2023.
//

import SwiftUI

let initPosition = CGPoint(x: 20, y: 20)
let initSize = CGSize(width: 320, height: 320)

struct ImageCropView: View {
    @StateObject private var imageCropVM = ImageCropViewModel.shared
    
    @State private var cropper = CGRect(origin: initPosition, size: initSize)
    @State private var imageSize: CGSize = .zero
    
    var inputImage: UIImage?
    
    @Binding var resultImage: UIImage?
    
    var completion: () -> Void
    
    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        let screenRatio = imageSize.width / imageSize.height
        let imageRatio = image.size.width / image.size.height
        
        var resizeRatio: CGFloat
        var paddingX = CGFloat.zero
        var paddingY = CGFloat.zero
        
        if imageRatio > screenRatio {
            resizeRatio = image.size.width / imageSize.width
            paddingY = (imageSize.height * resizeRatio - image.size.height) / 2
        } else {
            resizeRatio = image.size.height / imageSize.height
            paddingX = (imageSize.width * resizeRatio - image.size.width) / 2
        }
        
        let resizedRect = CGRect(origin: CGPoint(x: rect.minX * resizeRatio - paddingX, y: rect.minY * resizeRatio - paddingY), size: CGSize(width: rect.width * resizeRatio, height: rect.height * resizeRatio))
        guard let cgImage = image.cgImage?.cropping(to: resizedRect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFit()
                    
                    CropOverlay(cropRect: $cropper, inputImage: inputImage)
                    
                    Button {
                        imageSize = geo.size
                        let rs = cropImage(inputImage, toRect: cropper)
                        resultImage = rs
                        imageCropVM.isShowingCropper = false
                        completion()
                    } label: {
                        Text("Crop")
                    }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

    }
}

struct CropOverlay: View {
    @Binding var cropRect: CGRect
    
    let inputImage: UIImage
    let padding: CGFloat = 10
    
    @GestureState private var dragGesture: (dragOffset: CGSize, zoomLeftOffset: CGFloat, zoomRightOffset: CGFloat, zoomUpOffset: CGFloat, zoomDownOffset: CGFloat) = (CGSize.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
    @GestureState private var zoomOffset = CGSize.zero
    
    private func isDragToMove(touchPosition: CGPoint) -> Bool {
        let dragableRect = CGRect(
            origin:
                CGPoint(
                    x: cropRect.minX + padding,
                    y: cropRect.minY + padding
                ),
            size:
                CGSize(
                    width: cropRect.size.width - padding * 2,
                    height: cropRect.size.height - padding * 2
                )
        )
        return dragableRect.contains(touchPosition)
    }
    
    private func isDragToZoomLeft(touchPosition: CGPoint) -> Bool {
        let dragableRect = CGRect(
            origin:
                CGPoint(
                    x: cropRect.minX - padding,
                    y: cropRect.minY - padding
                ),
            size:
                CGSize(
                    width: padding * 2,
                    height: cropRect.size.height + padding * 2
                )
        )
        
        return dragableRect.contains(touchPosition)
    }
    
    private func isDragToZoomRight(touchPosition: CGPoint) -> Bool {
        let dragableRect = CGRect(
            origin:
                CGPoint(
                    x: cropRect.maxX - padding,
                    y: cropRect.minY - padding
                ),
            size:
                CGSize(
                    width: padding * 2,
                    height: cropRect.size.height + padding * 2
                )
        )
        
        return dragableRect.contains(touchPosition)
    }
    
    private func isDragToZoomUp(touchPosition: CGPoint) -> Bool {
        let dragableRect = CGRect(
            origin:
                CGPoint(
                    x: cropRect.minX - padding,
                    y: cropRect.minY - padding
                ),
            size:
                CGSize(
                    width: cropRect.size.width + padding * 2,
                    height: padding * 2
                )
        )
        
        return dragableRect.contains(touchPosition)
    }
    
    private func isDragToZoomDown(touchPosition: CGPoint) -> Bool {
        let dragableRect = CGRect(
            origin:
                CGPoint(
                    x: cropRect.minX - padding,
                    y: cropRect.maxY - padding
                ),
            size:
                CGSize(
                    width: cropRect.size.width + padding * 2,
                    height: padding * 2
                )
        )
        
        return dragableRect.contains(touchPosition)
    }
    
    var body: some View {
        //        VStack {
        GeometryReader { geo in
            Rectangle()
                .fill(Color.white.opacity(0.4))
                .overlay(
                    // Cropper
                    ZStack {
                        Rectangle()
                            .background(Color.white.opacity(0.5))
                            .overlay(
                                VStack {
                                    Image(uiImage: inputImage)
                                        .resizable()
                                        .scaledToFit()
                                }
                                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                                    .position(x: geo.size.width / 2 - cropRect.minX - dragGesture.dragOffset.width - dragGesture.zoomLeftOffset, y: geo.size.height / 2 - cropRect.minY - dragGesture.dragOffset.height - dragGesture.zoomUpOffset)
                            )
                            .clipped()
                    }
                        .frame(
                            width: cropRect.size.width - dragGesture.zoomLeftOffset
                            + dragGesture.zoomRightOffset,
                            height: cropRect.size.height - dragGesture.zoomUpOffset
                            + dragGesture.zoomDownOffset)
                        .position(
                            x: cropRect.midX
                            + dragGesture.dragOffset.width
                            + dragGesture.zoomLeftOffset / 2
                            + dragGesture.zoomRightOffset / 2,
                            y: cropRect.midY
                            + dragGesture.dragOffset.height
                            + dragGesture.zoomUpOffset / 2
                            + dragGesture.zoomDownOffset / 2
                        )
                        .gesture( // Gesture
                            DragGesture(minimumDistance: 1)
                                .updating($dragGesture) { value, state, _ in
                                    var dragOffset = CGSize.zero
                                    var zoomLeftOffset = CGFloat.zero
                                    var zoomRightOffset = CGFloat.zero
                                    var zoomUpOffset = CGFloat.zero
                                    var zoomDownOffset = CGFloat.zero
                                    
                                    if isDragToMove(touchPosition: value.startLocation) {
                                        dragOffset = value.translation
                                    } else {
                                        if isDragToZoomLeft(touchPosition: value.startLocation) {
                                            zoomLeftOffset = value.translation.width
                                        }
                                        if isDragToZoomRight(touchPosition: value.startLocation) {
                                            zoomRightOffset = value.translation.width
                                        }
                                        if isDragToZoomUp(touchPosition: value.startLocation) {
                                            zoomUpOffset = value.translation.height
                                        }
                                        if isDragToZoomDown(touchPosition: value.startLocation) {
                                            zoomDownOffset = value.translation.height
                                        }
                                    }
                                    
                                    state = (dragOffset, zoomLeftOffset, zoomRightOffset, zoomUpOffset, zoomDownOffset)
                                }
                                .onEnded { value in
                                    if isDragToMove(touchPosition: value.startLocation) {
                                        cropRect = cropRect.offsetBy(dx: value.translation.width, dy: value.translation.height)
                                        
                                    } else {
                                        var offsetX = CGFloat.zero
                                        var offsetY = CGFloat.zero
                                        
                                        if isDragToZoomLeft(touchPosition: value.startLocation) {
                                            cropRect.size.width -= value.translation.width
                                            offsetX = value.translation.width
                                        }
                                        if isDragToZoomRight(touchPosition: value.startLocation) {
                                            cropRect.size.width += value.translation.width
                                        }
                                        if isDragToZoomUp(touchPosition: value.startLocation) {
                                            cropRect.size.height -= value.translation.height
                                            offsetY = value.translation.height
                                        }
                                        if isDragToZoomDown(touchPosition: value.startLocation) {
                                            cropRect.size.height += value.translation.height
                                        }
                                        
                                        cropRect = cropRect.offsetBy(dx: offsetX, dy: offsetY)
                                    }
                                }
                        )
                )
                .overlay( // Stroke for cropper
                    Rectangle()
                        .stroke(Color.white.opacity(0.5), lineWidth: padding / 2)
                        .frame(
                            width: cropRect.size.width - dragGesture.zoomLeftOffset
                            + dragGesture.zoomRightOffset,
                            height: cropRect.size.height - dragGesture.zoomUpOffset
                            + dragGesture.zoomDownOffset)
                        .position(
                            x: cropRect.midX
                            + dragGesture.dragOffset.width
                            + dragGesture.zoomLeftOffset / 2
                            + dragGesture.zoomRightOffset / 2,
                            y: cropRect.midY
                            + dragGesture.dragOffset.height
                            + dragGesture.zoomUpOffset / 2
                            + dragGesture.zoomDownOffset / 2
                        )
                )
        }
    }
}
