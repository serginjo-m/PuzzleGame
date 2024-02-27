//
//  PhotoLoader.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 25/02/24.
//

import Foundation
import UIKit

//possible errors
enum ServiceError: Error {
    case invalidBaseUrl
    case noData
    case cancelled
    case unableToInitialize
}

struct PhotoApi { private init() {} }

extension PhotoApi {
    
    struct GetPhoto: PhotoLoaderServiceProtocol {
        
    }
}

protocol PhotoLoaderServiceProtocol {
    
    func fetchImage(completionHandler: @escaping (Outcome<UIImage>) -> ())
    
    var baseURL: String { get }
}

extension PhotoLoaderServiceProtocol {
    
    var baseURL: String
    {
        return "https://picsum.photos/1024"
    }
    
    func fetchImage(completionHandler: @escaping (Outcome<UIImage>) -> ()) {
        
        let session = URLSession.shared
        //if baseURL can't be converted into URL address - escapes
        guard let url = URL(string: baseURL) else {
            completionHandler(.failure(ServiceError.invalidBaseUrl))
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //check if error is of canceled and if data exists
            guard (error as NSError?)?.code != NSURLErrorCancelled, data != nil else {
                DispatchQueue.main.async { completionHandler(.failure(ServiceError.cancelled)) }
                return
            }
            
            guard let responseData = data else {
                //exits from function with a completion handler of type .noData
                DispatchQueue.main.async { completionHandler(.failure(ServiceError.noData)) }
                return
            }
            
            //try to initialize image with data
            guard let image: UIImage = UIImage(data: responseData) else {
                //exits from func with a completion handler of type unableToInitialize
                DispatchQueue.main.async { completionHandler(.failure(ServiceError.unableToInitialize )) }
                return
            }
            //success
            DispatchQueue.main.async { completionHandler(.success(image)) }
        }
        
        dataTask.resume()
        
    }
    
}
