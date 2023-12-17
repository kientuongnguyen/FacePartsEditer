//
//  ResultView.swift
//  FacePartsEditor
//
//  Created by Tran Cao Khanh Ngoc on 15/06/2023.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var languageVM = LanguageViewModel.shared

    var outputImage: UIImage?
    var inputImage: UIImage
    @State var showOutput = true

    @State var presentSavedToLib = false
    
    var body: some View {
        VStack {
            VStack {
                if let outputImage = outputImage {
                    Image(uiImage: showOutput ? outputImage : inputImage)
                        .resizable()
                        .scaledToFit()
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
            .onTapGesture {
                showOutput = !showOutput
            }
            
            Spacer()
            
            HStack {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            .padding()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Close".localized(languageVM.currentLanguage))
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
 
            Button {
                guard let image = outputImage else { return }

                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: image) {
                    presentSavedToLib = true
                }
            } label: {
                Text("Save".localized(languageVM.currentLanguage))
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .alert(isPresented: $presentSavedToLib) {
            Alert(title: Text("Image Saved!!!"))
        }
    }
    
}

