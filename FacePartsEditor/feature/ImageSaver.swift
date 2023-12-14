//
//  ImageSaver.swift
//  FacePartsEditor
//
//  Created by Tran Cao Khanh Ngoc on 01/10/2023.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    var completion: () -> Void = {}
    func writeToPhotoAlbum(image: UIImage, completion: @escaping () -> Void) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completion()
        print("Save finished!")
    }
}
