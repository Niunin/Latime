//
//  NetworkingUnsplash.swift
//  iX-33
//
//  Created by Andrea Nunti on 01.04.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Data Structure

enum NetworkManagerError: Error {
    
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
    
}

// MARK: - Object

class UnsplashNetworkService {
    
    // MARK: properties
    
    var key = "UQ2bF5MUYSMQzDfXp_uITypKwazQ0cFqQOVBo3pVFAw"
    let session = URLSession(configuration: .default)
    
    // MARK: request
    
    func requestDataPackage(searchQuery: String?, completion: @escaping (Data?, Error?) -> Void) {
        let urlComponents: URLComponents = makeURLComponents()
        let queryItems: [URLQueryItem] = makeQuery(searchQuery)
        guard let url = makeURL(from: urlComponents, with: queryItems) else {
            completion(nil, NetworkManagerError.badLocalUrl)
            return
        }
        let request: URLRequest = makeRequest(with: url)
        let task: URLSessionDataTask = makeDataTask(request: request, completion: completion)
        task.resume()
    }
    
    func requestImage(imageURL: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = makeDownloadTask(imageURL: imageURL, completion: completion)
        task.resume()
    }
    
}

// MARK: - Factories

private extension UnsplashNetworkService {
    
    func makeURLComponents() -> URLComponents {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.unsplash.com"
        urlConstructor.path = "/photos/random"
        return urlConstructor
    }
    
    func makeQuery(_ query: String?) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "count", value: "30"),
            URLQueryItem(name: "orientation", value: "landscape")
        ]
    }
    
    func makeURL(from components: URLComponents, with queryItems: [URLQueryItem]) -> URL? {
        var comp = components
        comp.queryItems = queryItems
        return comp.url
    }
    
    func makeRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(key)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func makeDataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            // Checking for error message abscence
            if error != nil {
                completion(nil, error)
                return
            }
            // Checking for succesfull 2xx response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            // Checking for data presence
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }
            // Everything is OK
            completion(data, nil)
        }
        return dataTask
    }
    
    func makeDownloadTask(imageURL: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDownloadTask {
        let downloadTask = URLSession.shared.downloadTask(with: imageURL) { localUrl, response, error in
            // Checking for error message abscence
            if error != nil {
                completion(nil, error)
                return
            }
            // Checking for succesfull 2xx response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        return downloadTask
    }
    
}
