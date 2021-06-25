//
//  NSFetchRequest+extension.swift
//  Project 4
//
//  Created by Andrea Nunti on 11.12.2020.
//

import Foundation


// MARK: - Extensions for Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

}

extension Decodable {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
}


