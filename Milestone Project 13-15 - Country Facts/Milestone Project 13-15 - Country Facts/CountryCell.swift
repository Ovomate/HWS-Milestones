//
//  CountryCell.swift
//  Milestone Project 13-15 - Country Facts
//
//  Created by Stefan Storm on 2024/09/29.
//

import UIKit

class CountryCell: UITableViewCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.clipsToBounds = true

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        setupCell()
        
        
    }
    
    
    func setupCell(){
        
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 5),
            nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),

            
            ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
