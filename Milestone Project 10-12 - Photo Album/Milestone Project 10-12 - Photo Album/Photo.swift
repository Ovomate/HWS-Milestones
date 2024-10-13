//
//  Photo.swift
//  Milestone Project 10-12 - Photo Album
//
//  Created by Stefan Storm on 2024/09/23.
//

import Foundation

class Photo: NSObject, Codable{
    
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
