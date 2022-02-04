//
//  ImageDownloader.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 04/02/22.
//

import Foundation

final class ImageDownloder {
  static func downloadImage(from url: URL, completion: @escaping (_ imageData: Data?, _ error: Error?)-> Void) {
    let dataTask = URLSession.shared.dataTask(with: url) {(data, responseData, error) in
      
      guard (error == nil) else {
        completion(nil, Failure(message: error?.localizedDescription))
        return
      }
      
      if let data = data {
        completion(data, nil)
      } else {
        completion(nil, Failure(message: error?.localizedDescription))
      }
    }
    
    // Start Data Task
    dataTask.resume()
  }
}
