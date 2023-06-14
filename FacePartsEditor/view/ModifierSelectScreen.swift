//
//  ModifierSelectScreen.swift
//  FacePartsEditor
//
//  Created by Tran Cao Khanh Ngoc on 24/05/2023.
//

import SwiftUI

let SIZE = 180.0
extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8 ) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            Label(
                title: { configuration.label },
                icon: {}
            )
        }
        .foregroundColor(configuration.isOn ? .white : .purple)
        .frame(width: 60)
        .padding()
        .background(configuration.isOn ? Color.pink.opacity(0.4) : Color.clear)
        .cornerRadius(5)
    }
}

struct ModifierSelectScreen: View {
    var inputImage: UIImage
    
    @State var inputDescription: String = "A human face"
    @State var outputDescription: String = ""
    @State var outputImage: UIImage?
    
    @State var processing = false
    
    @State var selectedList: [Bool] = [false, false, false, false, false, false, false, false, false, false]
    @State var test: [[Int]] = [[0], [1, 2], [3, 4], [5], [6], [7, 8, 9], [10]]
    var selection = ["face", "lb", "rb", "le", "re", "nose","ulip", "llip", "imouth", "hair"]
//    var selection = ["Face", "eyes brown", "eyes", "nose","mouth", "hair"]
//    var selectionImage = ["face.smiling", "eyebrow", "eye", "nose","mouth", "hair"]

    
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
            Text("Input image description")
                .padding(.bottom, 10)
                .bold()
                .foregroundColor(Color.purple.opacity(0.9))
            TextField("Enter description for input image", text: $inputDescription)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 16)
            
            Text("Output image description")
                .padding(.bottom, 10)
                .padding(.top, 20)
                .foregroundColor(Color.purple.opacity(0.9))
                .bold()
            
            TextField("Enter description for output image", text: $outputDescription)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 32)

            // Parts selection
            Text("Select face parts to modify")
                .padding(.bottom, 10)
                .foregroundColor(Color.purple.opacity(0.9))
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
                ForEach(Array($selectedList.enumerated()), id: \.offset) {id, $isOn in
                    Toggle(isOn: $isOn) {
                        Text(selection[id])
//                        Image(systemName: selectionImage[id])
                    }
                    .toggleStyle(CustomToggleStyle())
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(0xe4aadf).opacity(0.6))
            .cornerRadius(8)
            .padding(.bottom, 32)

            // Action Button
            VStack(alignment: .center) {
                actionButton
            }
            .frame(maxWidth: .infinity, alignment: .center)
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
                    if processing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                    } else {
                        EmptyView()
                    }
                }
                .frame(width: SIZE, height: SIZE)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private var actionButton: some View {
        Button {
            process()
        } label: {
            Text("Process")
        }
        .buttonStyle(.borderedProminent)
        
    }
    
    private func process() {
        processing = true
        outputImage = nil
        
        var selectedPart: [String] = []
        selectedList.enumerated().forEach { idx, isSelected in
            if isSelected {
//                selectedPart.append("\(test[idx])")
                selectedPart.append("\(idx)")
            }
        }
        
        ImageAPI.uploadImage(
            image: inputImage,
            description: inputDescription,
            targetDescription: outputDescription,
            parts: selectedPart.joined(separator: ",")
        ) { image in
            processing = false
            outputImage = image
        }
    }
}
