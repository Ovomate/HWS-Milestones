//
//  DetailViewController.swift
//  Milestone Project 1-3
//
//  Created by Stefan Storm on 2024/08/28.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedFlag: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageToLoad = selectedFlag{
            imageView.image = UIImage(named: imageToLoad)
            imageView.layer.borderWidth = 1
        }
        
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    

    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let imageName = selectedFlag else{
            print("No image")
            return
        }
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    
}
