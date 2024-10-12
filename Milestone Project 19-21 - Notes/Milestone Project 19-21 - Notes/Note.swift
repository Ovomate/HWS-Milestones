//
//  Note.swift
//  Milestone Project 19-21 - Notes
//
//  Created by Stefan Storm on 2024/10/12.
//

import Foundation

class Note: Codable {
    
    var title : String
    var content : String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
}
