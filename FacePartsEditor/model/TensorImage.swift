//
//  TensorImage.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 26/02/2023.
//

import Foundation
import UIKit

struct TensorImage {
    let uiImage: UIImage
    
    func toNumpyArray() -> [Int]? {
        uiImage.toRGB()
    }
}
