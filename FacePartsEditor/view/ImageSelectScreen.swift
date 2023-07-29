//
//  ImageSelectScreen.swift
//  FacePartsEditor
//
//  Created by Trần Cao Khánh Ngọc on 24/05/2023.
//

import SwiftUI

struct ImageSelectScreen: View {
    @ObservedObject var imageCropVM = ImageCropViewModel.shared
    
    @State var croppedImage: UIImage?
    @State var pickedImage: UIImage?
    
    @State var isLoading = false
    @State var showsImagePicker = false
    @State var showsModificationSelection = false
    
    var body: some View {
        VStack {
            imageSelect
        }
    }
    
    private var imageSelect: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            VStack {
                ZStack(alignment: .center) {
                    if let image = croppedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 320)
                    } else {
                        VStack {
                            Text("Tap to select Image")
                        }
                        .frame(width: 320, height: 480)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isLoading = true
                            showsImagePicker = true
                        }
                    }
                    
                    if isLoading {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            }
            .frame(width: 320, height: 480)
            .background(croppedImage == nil ? Color.gray.opacity(0.5) : Color.clear)
            
            Spacer(minLength: 30)
            
            VStack {
                Button {
                    pickedImage = nil
                    isLoading = true
                    showsImagePicker = true
                } label: {
                    Text("Re - Select")
                }
                .buttonStyle(.bordered)
                .disabled(croppedImage == nil)
                
                Button {
                    showsModificationSelection = true
                } label: {
                    Text("Select")
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .sheet(isPresented: $showsModificationSelection) {
//            ContentView()
            if let inputImage = croppedImage {
                ModifierSelectScreen(inputImage: inputImage)
            }
        }
        .sheet(isPresented: $imageCropVM.isShowingCropper) {
            ImageCropView(inputImage: pickedImage, resultImage: $croppedImage) {
                self.isLoading = false
            }
        }
        .sheet(
            isPresented: $showsImagePicker,
            onDismiss: {
                isLoading = false
                if let _ = pickedImage {
                    imageCropVM.isShowingCropper = true
                }
            }) {
                ImagePicker(
                    uiImage: self.$pickedImage)
            }
    }
}

struct ImageSelectScreen_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectScreen()
    }
}
