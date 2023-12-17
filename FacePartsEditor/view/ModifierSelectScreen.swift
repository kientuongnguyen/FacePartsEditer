//
//  ModifierSelectScreen.swift
//  FacePartsEditor
//
//  Created by Tran Cao Khanh Ngoc on 24/05/2023.
//

import SwiftUI

let SIZE = 250.0
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
        .padding(.vertical, 4)
        .background(configuration.isOn ? Color.pink.opacity(0.4) : Color.clear)
        .cornerRadius(5)
    }
}

struct ModifierSelectScreen: View {
    @ObservedObject private var languageVM = LanguageViewModel.shared
    var inputImage: UIImage
    
    @State var inputDescription: String = "A human face".localized(LanguageViewModel.shared.currentLanguage)
    @State var outputDescription: String = ""
    @State var outputImage: UIImage?
    @State var showsResult = false
    @State var alpha: CGFloat = 35
    @State var beta: CGFloat = 15
    
    let alphaMin: CGFloat = -100
    let alphaMax: CGFloat = 100
    let alphaStep: CGFloat = 1
    
    let betaMin: CGFloat = 8
    let betaMax: CGFloat = 30
    let betaStep: CGFloat = 1
    
    @State var processing = false
    
    @State var selectedList: [Bool] = [true, false, false, false, false, false, false, false, false, false]
    @State var test: [[Int]] = [[1], [2], [3], [4], [5], [6], [7], [8], [9], [10]]
    var selection = ["face", "eyebrow-left", "eyebrow-right", "eye-left", "eye-right", "nose","ulip", "llip", "mouth", "hair"]

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // Images
                HStack {
                    inputImageView
                    Spacer()
                    inputSelectPart
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.bottom, 0)
                
                // Description
                Text("Input image description".localized(languageVM.currentLanguage))
                    .padding(.bottom, 10)
                    .bold()
                    .foregroundColor(Color.purple.opacity(0.9))
                TextField("Enter description for input image".localized(languageVM.currentLanguage), text: $inputDescription)
                    .textFieldStyle(.roundedBorder)
                
                Text("Output image description".localized(languageVM.currentLanguage))
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .foregroundColor(Color.purple.opacity(0.9))
                    .bold()
                
                TextField("Enter description for output image".localized(languageVM.currentLanguage), text: $outputDescription)
                    .textFieldStyle(.roundedBorder)
                
                Text(
                    "Alpha".localized(languageVM.currentLanguage) + String(format: ": %.2f", alpha / 10)
                )
                    .padding(.bottom, 10)
                    .padding(.top, 20)
                    .foregroundColor(Color.purple.opacity(0.9))
                    .bold()
                Slider(
                    value: $alpha,
                    in: alphaMin...alphaMax,
                    step: alphaStep
                ) {
                    Text("alpha".localized(languageVM.currentLanguage))
                } minimumValueLabel: {
                    Text("-10")
                } maximumValueLabel: {
                    Text("10")
                } onEditingChanged: { alpha in
                }
                
                Text(
                    "Beta".localized(languageVM.currentLanguage) + String(format: ": %.2f", beta / 100)
//                    "\(beta / 100)"
                )
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .foregroundColor(Color.purple.opacity(0.9))
                    .bold()
                Slider(
                    value: $beta,
                    in: betaMin...betaMax,
                    step: betaStep
                ){
                    Text("beta".localized(languageVM.currentLanguage))
                } minimumValueLabel: {
                    Text("0.08")
                } maximumValueLabel: {
                    Text("0.3")
                }

                // Action Button
                VStack(alignment: .center) {
                    actionButton
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
            }
            .padding(20)

            if (processing) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
            }
        }
        .sheet(isPresented: $showsResult) {
            
            ResultView(outputImage: outputImage, inputImage: inputImage)
        }
    }
    
    private var inputSelectPart: some View {
        LazyVGrid(columns: [GridItem()], spacing: 2) {
            ForEach(Array($selectedList.enumerated()), id: \.offset) {id, $isOn in
                Toggle(isOn: $isOn) {
                    if let uiImage = UIImage(named: selection[id]) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .interpolation(.high)
                            .scaledToFit()
                            .frame(height: 25)

                    } else {
                        Text(selection[id])

                    }
//                        Image(systemName: selectionImage[id])
                }
                .toggleStyle(CustomToggleStyle())
            }
        }
        .frame(width: 80)
        .background(Color(0xe4aadf).opacity(0.6))
        .cornerRadius(8)
        .padding(.bottom, 20)
    }
    private var inputImageView: some View {
        Image(uiImage: inputImage)
            .resizable()
            .scaledToFit()
            .frame(width: SIZE, height: SIZE)
    }
    
//    private var outputImageView: some View {
//        VStack {
//
//            if let outputImage = outputImage {
//                Image(uiImage: outputImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: SIZE, height: SIZE)
//            } else {
//                VStack {
//                    if processing {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle())
//                            .scaleEffect(2)
//                    } else {
//                        EmptyView()
//                    }
//                }
//                .frame(width: SIZE, height: SIZE)
//                .background(Color.black.opacity(0.5))
//                .edgesIgnoringSafeArea(.all)
//            }
//        }
//    }
    
    private var actionButton: some View {
        Button {
            process()
        } label: {
            Text("Process".localized(languageVM.currentLanguage))
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(8)

    }
    
    private func process() {
        processing = true
        outputImage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            processing = false
            showsResult = true
        }
        
        var selectedPart: [String] = []
        selectedList.enumerated().forEach { idx, isSelected in
            if isSelected {
                selectedPart.append(contentsOf: test[idx].map { "\($0)" })
//                selectedPart.append(test[idx].map { "\($0)" }.joined(separator: ","))
//                selectedPart.append("\(idx)")
            }
        }
        
        ImageAPI.uploadImage(
            image: inputImage,
            description: inputDescription,
            targetDescription: outputDescription,
            parts: selectedPart.joined(separator: ","),
            alpha: alpha / 10,
            beta: beta / 100
        ) { image in
            processing = false
            outputImage = image
        }
    }
}
