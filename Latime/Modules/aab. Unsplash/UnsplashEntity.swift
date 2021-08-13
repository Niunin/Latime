//
//  UnsplashEntity.swift
//  Timeboy
//
//  Created by Andrei Niunin on 02.05.2021.
//

import Foundation

// MARK: - Data Structure

struct ImageSource: Codable {
    
    var id: String
    var username: String
    var link: String
    var thumbUrl: String
    var regularUrl: String
    
    // MARK: init
    
    init(from unsplash: UnsplashPhoto) {
        id = unsplash.id
        username = unsplash.user.username
        link = unsplash.links.html
        thumbUrl = unsplash.urls.thumb
        regularUrl = unsplash.urls.regular
    }
    
}
