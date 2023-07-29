//
//  ResultView.swift
//  FacePartsEditor
//
//  Created by Tran Cao Khanh Ngoc on 15/06/2023.
//

import SwiftUI

struct ResultView: View {
    var outputImage: UIImage?
    var inputImage: UIImage
    
    var body: some View {
        VStack {
            VStack {
                if let outputImage = outputImage {
                    Image(uiImage: outputImage)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
            }
            .frame(height: 400)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(outputImage == nil ? Color.black.opacity(0.4) : Color.clear)
            .padding()
            
            Spacer()

            HStack {
                Spacer()
                Image(uiImage: inputImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
    
}

