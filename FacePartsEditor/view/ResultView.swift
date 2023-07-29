//
//  ResultView.swift
//  FacePartsEditor
//
//  Created by Tran Cao Khanh Ngoc on 15/06/2023.
//

import SwiftUI

struct ResultView: View {
    var outputImage: UIImage
    var inputImage: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: outputImage)
            Spacer()
            HStack {
                Spacer()
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.5)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
}
