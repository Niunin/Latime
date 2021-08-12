//
//  UnsplashResponce.swift
//  iX-33
//
//  Created by Andrea Nunti on 06.04.2021.
//

import Foundation

// MARK: - UnsplashFetch

struct UnsplashPhoto: Codable {
    
    let id: String
    let urls: Urls
    let links: Links
    let user: User

    struct Urls: Codable {
        let regular, small, thumb: String
    }

    struct Links: Codable {
        let html: String
    }

    struct User: Codable {
        let id: String
        let username: String
    }
    
}

struct UnsplashPhotoPack: Codable {
    
    let pack: [UnsplashPhoto]
    
}
