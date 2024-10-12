//
//  Data.swift
//  Milestone Project 19-21 - Notes
//
//  Created by Stefan Storm on 2024/10/12.
//

import Foundation


class DataModel {
    
    let defaults = UserDefaults.standard
    
    func retrieveNotes() -> [Note]{
        let savedNotes = defaults.object(forKey: "notes") as? Data 
        let jsonDecoder = JSONDecoder()
        var notes = [Note]()
        
        do{
            notes = try jsonDecoder.decode([Note].self, from: savedNotes ?? Data())
        }catch{
            print("Failed")
        }
        
        return notes
    }
    
    
    func saveNotes(_ notes: [Note]){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes){
            defaults.set(savedData, forKey: "notes")
        }else{
            print("Save failure")
        }
    }
    
    
}
