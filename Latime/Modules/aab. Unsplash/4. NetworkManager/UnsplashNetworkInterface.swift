//
//  UnsplashDataFetcher.swift
//  iX-33
//
//  Created by Andrea Nunti on 03.04.2021.
//

import Foundation

// MARK: - Object

// FIXME: interface should not inherit service
class UnsplashNetworkInterface: UnsplashNetworkService {
    
    // MARK: properties
    
    private var imagesCache = NSCache<NSString, NSData>()
    
    // MARK: fetch
    
    func fetchImagesDataPackage(searchQuery: String?, completion: @escaping (Data?, Error?) -> Void) {
        requestDataPackage(searchQuery: searchQuery, completion: completion)
    }
    
    // Reneame parameter name 
    func fetchImage(url: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(nil, NetworkManagerError.badLocalUrl)
            return
        }
        if checkCacheAndUse(for: imageUrl, completion: completion) { return }
        requestImage(imageURL: imageUrl, completion: completion)
    }
    
    private func checkCacheAndUse(for url: URL, completion: @escaping (Data?, Error?) -> Void) -> Bool {
        if let imageData = imagesCache.object(forKey: url.absoluteString as NSString) {
            Swift.debugPrint(" Cache is used")
            completion(imageData as Data, nil)
            return true
        } else {
            return false
        }
    }
    
}
