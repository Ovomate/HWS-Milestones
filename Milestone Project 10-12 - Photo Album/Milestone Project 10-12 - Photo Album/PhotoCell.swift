//
//  PhotoCell.swift
//  Milestone Project 10-12 - Photo Album
//
//  Created by Stefan Storm on 2024/09/23.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupContentView()
        setupCell()
                
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Caption This!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "DINAlternate-Bold", size: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        return button
    }()
    
    
    
    func setupContentView(){
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    
    
    func setupCell(){
        self.addSubview(imageView)
        self.addSubview(captionLabel)
        self.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10) ,
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            
            captionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            captionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            editButton.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            editButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1)
            
            
            ])
        
        
    }

}
