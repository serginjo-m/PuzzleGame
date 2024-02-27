//
//  PhotoLoader.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 25/02/24.
//

import Foundation
import UIKit

//router error cases enum
enum ServiceError: Error
{
    case invalidBaseUrl
    case noData
    case cancelled
    case unableToInitialize
}


//TODO: is it possible to do this a bit shorter?
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
    
    //TODO: Definitely should test this THROWS
    func fetchImage(completionHandler: @escaping (Outcome<UIImage>) -> ()) {
        
        let session = URLSession.shared
        
        guard let url = URL(string: baseURL) else {
            completionHandler(.failure(ServiceError.invalidBaseUrl))
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //check if error is of some kind type, than check if data exists/ returned
            guard (error as NSError?)?.code != NSURLErrorCancelled, data != nil else {
                //completion(.failure(NetworkResponse.cancelled))
                DispatchQueue.main.async { completionHandler(.failure(ServiceError.cancelled)) }
                return
            }
            
            //check if data exists
            guard let responseData = data else{
                //exits from function with a completion handler of type .noData
                DispatchQueue.main.async { completionHandler(.failure(ServiceError.noData)) }
                return
            }
            
            //try to parse data models into array of "ExpectedResponseModelType"
            guard let image: UIImage = UIImage(data: responseData) else
            {
                //exits from func with a completion handler of type .unableToDecode
                DispatchQueue.main.async { completionHandler(.failure(ServiceError.unableToInitialize )) }
                return
            }
            
            DispatchQueue.main.async { completionHandler(.success(image)) }
            
        }
        
        dataTask.resume()
        
    }
    
}
