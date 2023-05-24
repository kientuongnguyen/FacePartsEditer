//
//  APIClient.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 26/02/2023.
//

import Foundation

class APIClient {
    func request(_ request: URLRequest, completion: @escaping (_ : Result) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.error(error: error))
            } else if let data = data {
                completion(.success(json: data))
            } else {
                completion(.error(error: nil))
            }
        }
        task.resume()
    }
}

extension APIClient {
    enum Result {
        case success(json: Data)
        case error(error: Error?)
    }
}
