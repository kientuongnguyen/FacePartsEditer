//
//  ImagePicker.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 26/02/2023.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @Binding var image: Image?
    @Binding var uiImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var uiImage: UIImage?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, uiImage: Binding<UIImage?>) {
            _presentationMode = presentationMode
            _image = image
            _uiImage = uiImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.uiImage = uiImage
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, uiImage: $uiImage)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
}
