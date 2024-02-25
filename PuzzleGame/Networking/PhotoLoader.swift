//
//  PhotoLoader.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 25/02/24.
//

import Foundation
import UIKit
//TODO: They would like struct over class
class PhotoLoader {
    
    static var shared = PhotoLoader()
    
    //TODO: rename it later
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: urlString)
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
        
        dataTask.resume()
        
    }
    
}
