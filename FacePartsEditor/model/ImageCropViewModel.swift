//
//  ImageCropViewModel.swift
//  FacePartsEditor
//
//  Created by Trần Cao Khánh Ngọc on 26/04/2023.
//

import Foundation
import UIKit

class ImageCropViewModel: ObservableObject {
    private static var sharedInstance: ImageCropViewModel?
    class var shared : ImageCropViewModel {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = ImageCropViewModel()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        
        return sharedInstance
    }
    
    @Published var inputImage: UIImage?
    @Published var croppedImage: UIImage?
    @Published var isShowingCropper = false
}
