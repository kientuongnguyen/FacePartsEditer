//
//  ContentView.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 26/02/2023.
//

import SwiftUI

let appBackGroundColor = Color.cyan

class CheckBoxItems: ObservableObject {
    @Published var list: [CheckBoxItem]
    
    init(list: [CheckBoxItem]) {
        self.list = list
    }
}

class CheckBoxItem: ObservableObject {
    @Published var isSelected: Bool
    var name: String
    
    init(isSelected: Bool, name: String) {
        self.isSelected = isSelected
        self.name = name
    }
}

struct ContentView: View {
    
    @StateObject var imageCropVM = ImageCropViewModel.shared
    @State var showsImagePicker = false
    @State var showsResultImage = false
    
    @State var image: Image?
    @State var uiImage: UIImage?
    @State var croppedImage: UIImage?
    @State var resultImages: [Image]?
    
    @State var description: String = ""
    @State var targetDescription: String = ""
    
    @State var selectedList: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    var selection = ["background", "face", "lb", "rb", "le", "re", "nose","ulip", "llip", "imouth", "hair", "lr", "rr", "neck", "cloth", "eyeg", "hat", "earr"]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 32) {
                    ZStack {
                        if let image = croppedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            Text("Tap to select Image")
                        }
                    }
                    .frame(height: 200, alignment: .center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(image == nil ? Color.gray.opacity(0.5) : Color.clear)
                    .onTapGesture {
                        showsImagePicker = true
                    }
                    .sheet(isPresented: $showsImagePicker, onDismiss: {
                        if let uiImage = uiImage {
                            imageCropVM.isShowingCropper = true
                        }
                    }) {
                        ImagePicker(image: self.$image, uiImage: self.$uiImage)
                    }
                    
                    TextField("Description", text: $description)
                    TextField("Target", text: $targetDescription)
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
                        ForEach(Array($selectedList.enumerated()), id: \.offset) {id, $isOn in
                            Toggle(isOn: $isOn) {
                                Text(selection[id])
                            }
                            .toggleStyle(ButtonToggleStyle())
                        }
                    }
                    Button("Process") {
                        processImage()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding()
            //            .background(appBackGroundColor)
            .frame(alignment: .top)
            //            .sheet(isPresented: $showsResultImage) {
            //
            //                if let images = resultImages, !images.isEmpty {
            ////                    ScrollView {
            //                        HStack {
            //                            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
            //                                image
            //                                    .resizable()
            //                                    .scaledToFit()
            //                            }
            //                        }
            //                        .frame(maxWidth: .infinity, alignment: .center)
            ////                    }
            //                }
            //            }
            if showsResultImage {
                //                    ScrollView {
                VStack {
                    if let images = resultImages, !images.isEmpty {
                        
                        ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: (uiImage?.size.width ?? 0) / 3, height: (uiImage?.size.height ?? 0) / 3, alignment: .center)
                        }
                        
                        Button {
                            resultImages = nil
                            showsResultImage = false
                        } label: {
                            Text("back")
                        }
                        
                    } else {
                        Text("Loading...")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(appBackGroundColor)
                //                    }
                
                
            }
            
            if imageCropVM.isShowingCropper {
                ImageCropView(inputImage: uiImage, resultImage: $croppedImage)
            }
        }
        
    }
    
    private func processImage() {
        resultImages?.removeAll()
        showsResultImage = true
        
        if let uiImage = croppedImage {
            resultImages = []
            var selectedPart: [String] = []
            selectedList.enumerated().forEach { idx, isSelected in
                if isSelected {
                    selectedPart.append("\(idx)")
                }
            }
            ImageAPI.uploadImage(image: uiImage, description: description, targetDescription: targetDescription, parts: selectedPart.joined(separator: ",")) { image in
                resultImages?.append(Image(uiImage: image))
                //                showsResultImage = true
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
