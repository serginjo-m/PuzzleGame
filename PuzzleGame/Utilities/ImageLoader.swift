//
//  ImageLoader.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 24/02/24.
//

import Foundation
import UIKit

//cashed image object
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    @discardableResult//let's you ignore the return statement of the function
    func imageFromURL(url: URL?, placeholder: UIImage = #imageLiteral(resourceName: "nature")) -> URLSessionTask?{
        
        //check url, if not set placeholder to an image(that is a property of UIImaage)
        guard let url = url else { image = placeholder; return nil }
        
        
        //check for cache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            
            image = cachedImage
            
            return nil
        }
        
        
        //assign cached image to UIImage property
        image = placeholder
        
        
        //if image isn't cached, try to get it from url session
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in

            //check if error is of some kind type, than check if data exists/ returned
            guard (error as NSError?)?.code != NSURLErrorCancelled, data != nil else { return}
            
            //check for error
            guard error == nil else {
                //if error -> set an image to placeholder (that is some default image) in background
                DispatchQueue.main.async { self.image = placeholder }
                return
            }
            
            //if everything is OK
            DispatchQueue.main.async {
                //unwrap optional data / and then try to create UIImage based on "data"
                if let data = data, let image = UIImage(data: data) {
                    //cache that image to be available in future
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    //set UIImage property to that image
                    self.image = image
                } else {
                    //if something is wrong, set UIImage to placeholder
                    self.image = placeholder
                }
            }
        })
        task.resume()//escape from URLSession
        return task//return task, but because of using @discardableResult it doesn't "appear" in code, I assume
    }
}

