//
//  DetailsViewController.swift
//  Milestone Project 13-15 - Country Facts
//
//  Created by Stefan Storm on 2024/09/29.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var detailedCountry: Country!
    
    var flagImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        return label
    }()
    
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupDetailsViewController()

       
        if let detailedCountry = detailedCountry{
            
            title = detailedCountry.commonName
            detailsLabel.text = """
            Name: \(detailedCountry.commonName)
            
            Capital: \(detailedCountry.capital)
            
            Population: \(String(detailedCountry.population))
            
            Area: \(String(detailedCountry.area))
            
            Region: \(detailedCountry.region)
            """
            
            if let url = URL(string: detailedCountry.flag){
                downloadFlagImage(from: url)
                
            }
        }
        
    }
    
    
    func setupDetailsViewController(){
        view.addSubview(flagImageView)
        view.addSubview(separatorView)
        view.addSubview(detailsLabel)
        view.addSubview(bottomSeparatorView)
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            flagImageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
            flagImageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -5),
            flagImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            separatorView.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            detailsLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -5),
            detailsLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            bottomSeparatorView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 10),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            
        
        
        ])
        
    }
    
    
    // Function to download the flag image from the URL and set it to the UIImageView
     func downloadFlagImage(from url: URL) {
         let imageTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
             if let error = error {
                 print("Error downloading image: \(error.localizedDescription)")
                 return
             }

             // Check if data is valid
             if let data = data, let image = UIImage(data: data) {
                 // Update the UIImageView on the main thread
                 DispatchQueue.main.async {
                     self.flagImageView.image = image
                 }
             }
         }
         imageTask.resume()
     }
    
    
    
 }
    



