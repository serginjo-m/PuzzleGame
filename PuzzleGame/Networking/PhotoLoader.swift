//
//  PhotoLoader.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 25/02/24.
//

import Foundation
import UIKit
//TODO: is it possible to do this a bit shorter?
struct PhotoApi { private init() {} }

extension PhotoApi {
    
    struct GetPhoto: PhotoLoaderServiceProtocol {
        
    }
}

protocol PhotoLoaderServiceProtocol {
    func fetchImage(completionHandler: @escaping (_ data: Data?) -> ())
    
    var baseURL: String { get }
}

extension PhotoLoaderServiceProtocol {
    
    var baseURL: String
    {
        return "https://picsum.photos/1024"
    }
    
    //TODO: 
    func fetchImage(completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        guard let url = URL(string: baseURL) else { completionHandler(nil); return}
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //check if error is of some kind type, than check if data exists/ returned
            guard (error as NSError?)?.code != NSURLErrorCancelled, data != nil else {
                DispatchQueue.main.async { completionHandler(nil) }
                return
            }
            
            if error != nil {
                DispatchQueue.main.async { completionHandler(nil) }
            } else {
                DispatchQueue.main.async { completionHandler(data) }
            }
        }
        
        dataTask.resume()
        
    }
    
}
