//
//  ModifierSelectScreen.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 24/05/2023.
//

import SwiftUI

let SIZE = 180.0

struct ModifierSelectScreen: View {
    var inputImage: UIImage
    
    @State var inputDescription: String = "A human face"
    @State var outputDescription: String = ""
    @State var outputImage: UIImage?
    
    @State var selectedList: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    var selection = ["background", "face", "lb", "rb", "le", "re", "nose","ulip", "llip", "imouth", "hair", "lr", "rr", "neck", "cloth", "eyeg", "hat", "earr"]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Images
            HStack {
                inputImageView
                Spacer()
                outputImageView
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.bottom, 32)
            
            // Description
            Text("Output image description")
            TextField("Enter description for output image", text: $outputDescription)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 32)

            // Parts selection
            Text("Select face parts to modify")
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
                ForEach(Array($selectedList.enumerated()), id: \.offset) {id, $isOn in
                    Toggle(isOn: $isOn) {
                        Text(selection[id])
                    }
                    .toggleStyle(ButtonToggleStyle())
                }
            }
            .background(Color.pink.opacity(0.6))
            .cornerRadius(8)
        }
        .padding(20)
    }
    
    private var inputImageView: some View {
        Image(uiImage: inputImage)
            .resizable()
            .scaledToFit()
            .frame(width: SIZE, height: SIZE)
    }
    
    private var outputImageView: some View {
        VStack {
            
            if let outputImage = outputImage {
                Image(uiImage: outputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SIZE, height: SIZE)
            } else {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
                .frame(width: SIZE, height: SIZE)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

//struct ModifierSelectScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifierSelectScreen()
//    }
//}
