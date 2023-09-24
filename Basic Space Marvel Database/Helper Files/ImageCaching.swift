//
//  ImageCaching.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation
import UIKit


class ImageCaching
{
    private let imageCache = NSCache<NSString, UIImage>()
    private let networkManager: NetworkManager?
    private(set) var imageKeys: [NSString]
    
    init(networkManager: NetworkManager?)
    {
        self.networkManager = networkManager
        imageKeys = []
    }
    
    func getImage(path: String, imageExtension: String, completion: @escaping (UIImage?) -> Void)
    {
        let photoURL = "\(path).\(imageExtension)"
        let imageKey = NSString(string: photoURL)
        if let cachedImage = imageCache.object(forKey: imageKey)
        {
            completion(cachedImage)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async
        {
        
            [weak self] in
            
            guard let self = self else { completion(nil); return }
            
            self.networkManager?.request(requestURL: photoURL)
            {
                serverResponse, data, error in
                
                guard let data = data else { completion(nil); return }
                let photo = UIImage(data: data)
                
                guard let image = UIImage(data: data) else { completion(nil); return }
                self.imageCache.setObject(image, forKey: imageKey)
                
                completion(photo)
            }
//            guard let image = UIImage(named: String(imageKey)) else { completion(nil); return }
            
//            completion(image)
        }
    }
}
