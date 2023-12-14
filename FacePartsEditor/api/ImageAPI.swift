//
//  ImageAPI.swift
//  FacePartsEditor
//
//  Created by Trần Cao Khánh Ngọc on 26/02/2023.
//

import Foundation
import UIKit

class ImageAPI {
    static let baseURLString = "http://bed8-104-198-38-254.ngrok-free.app/"
    static let uploadURL = URL(string: "\(baseURLString)process")!
    static let alignURL = URL(string: "\(baseURLString)align")!

    static func uploadImage(image: UIImage, description: String, targetDescription: String, parts: String, alpha: CGFloat, beta: CGFloat, completion: @escaping (UIImage) -> Void) {
        let fileName = "uploadedImage.jpg"
        let url = uploadURL
        
        let session = URLSession.shared
        
        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        let parameter1 = description
        let parameter1Data = parameter1.data(using: .utf8)!
        let parameter2 = targetDescription
        let parameter2Data = parameter2.data(using: .utf8)!
        let alphaString = "\(alpha)"
        let alphaData = alphaString.data(using: .utf8)!
        let betaString = "\(beta)"
        let betaData = betaString.data(using: .utf8)!
        let intListData = parts
        let parameterData = intListData.data(using: .utf8)!
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
        let paramName = "file"
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"parameter1\"\r\n\r\n".data(using: .utf8)!)
        data.append(parameter1Data)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"parameter2\"\r\n\r\n".data(using: .utf8)!)
        data.append(parameter2Data)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"alpha\"\r\n\r\n".data(using: .utf8)!)
        data.append(alphaData)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"beta\"\r\n\r\n".data(using: .utf8)!)
        data.append(betaData)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"parts\"\r\n\r\n".data(using: .utf8)!)
        data.append(parameterData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Unexpected response")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Error: Invalid status code \(httpResponse.statusCode)")
                return
            }
            
            guard let imageData = responseData else {
                print("Error: No image data returned")
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print("Error: Unable to create image from data")
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }).resume()
    }
    
    static func alignImage(image: UIImage, description: String, targetDescription: String, parts: String, alpha: CGFloat, beta: CGFloat, completion: @escaping (UIImage) -> Void) {
        let fileName = "uploadedImage.jpg"
        let url = alignURL
        
        let session = URLSession.shared
        
        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        let parameter1 = description
        let parameter1Data = parameter1.data(using: .utf8)!
        let parameter2 = targetDescription
        let parameter2Data = parameter2.data(using: .utf8)!
        let alphaString = "\(alpha)"
        let alphaData = alphaString.data(using: .utf8)!
        let betaString = "\(beta)"
        let betaData = betaString.data(using: .utf8)!
        let intListData = parts
        let parameterData = intListData.data(using: .utf8)!
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
        let paramName = "file"
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"parameter1\"\r\n\r\n".data(using: .utf8)!)
        data.append(parameter1Data)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"parameter2\"\r\n\r\n".data(using: .utf8)!)
        data.append(parameter2Data)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"alpha\"\r\n\r\n".data(using: .utf8)!)
        data.append(alphaData)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"beta\"\r\n\r\n".data(using: .utf8)!)
        data.append(betaData)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"parts\"\r\n\r\n".data(using: .utf8)!)
        data.append(parameterData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Unexpected response")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Error: Invalid status code \(httpResponse.statusCode)")
                return
            }
            
            guard let imageData = responseData else {
                print("Error: No image data returned")
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print("Error: Unable to create image from data")
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }).resume()
    }
    
    func startImageSegmentation() {
        
    }
}
