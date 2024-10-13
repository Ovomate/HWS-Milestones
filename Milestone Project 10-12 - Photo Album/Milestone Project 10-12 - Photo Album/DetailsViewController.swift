//
//  DetailsViewController.swift
//  Milestone Project 10-12 - Photo Album
//
//  Created by Stefan Storm on 2024/09/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var selectedImage: String?
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        

        if let imageToLoad = selectedImage{
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
            
        setupViewContoller()
    }
    
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        return paths[0]
    }
    
    

    func setupViewContoller(){
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75)
            
            
            ])
        
        
    }

}
