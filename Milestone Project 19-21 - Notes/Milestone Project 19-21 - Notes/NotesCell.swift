//
//  NotesTableViewCell.swift
//  Milestone Project 19-21 - Notes
//
//  Created by Stefan Storm on 2024/10/12.
//

import UIKit

class NotesCell: UITableViewCell {
    
    
    var noteContentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 33.0/255, green: 33.0/255, blue: 33/255, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    var noteTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Test text"
        view.numberOfLines = 1
        view.font = UIFont(name: "Arial Black", size: 18)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textAlignment = .left
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        return view
    }()
    
    var noteContent: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Test text"
        view.numberOfLines = 1
        view.font = UIFont(name: "Arial Black", size: 14)
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textColor = .darkGray
        view.textAlignment = .left
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        return view
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .black
        
        setupCell()
    }
    

    func setupCell(){
        
        self.addSubview(noteContentView)
        noteContentView.addSubview(noteTitle)
        noteContentView.addSubview(noteContent)
        
        NSLayoutConstraint.activate([
            noteContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            noteContentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            noteContentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            noteContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            noteTitle.topAnchor.constraint(equalTo: noteContentView.topAnchor, constant: 2.5),
            noteTitle.leftAnchor.constraint(equalTo: noteContentView.leftAnchor),
            noteTitle.rightAnchor.constraint(equalTo: noteContentView.rightAnchor),
            noteTitle.heightAnchor.constraint(equalTo: noteContentView.heightAnchor, multiplier: 0.4),
            
            noteContent.topAnchor.constraint(equalTo: noteTitle.bottomAnchor, constant: 1),
            noteContent.leftAnchor.constraint(equalTo: noteContentView.leftAnchor),
            noteContent.rightAnchor.constraint(equalTo: noteContentView.rightAnchor),
            noteContent.heightAnchor.constraint(equalTo: noteContentView.heightAnchor, multiplier: 0.4),
            

            ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
