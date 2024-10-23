//
//  ViewController.swift
//  Milestone Project 25-27 - Meme Generator
//
//  Created by Stefan Storm on 2024/10/23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.black.cgColor
        iv.contentMode = .scaleAspectFit
        return iv
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        
        navigationItem.rightBarButtonItems = [add, share]
        
        setupView()
    }
    
    
    @objc func shareMeme(){
        if let image = imageView.image?.pngData() {
            let vc = UIActivityViewController(activityItems:[image], applicationActivities: nil)
            present(vc, animated: true)
        }
    }
    
    @objc func addPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func inputHeadeAndFooter(photo: UIImage){
        let ac = UIAlertController(title: "Enter meme header & footer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        
        let inputAction = UIAlertAction(title: "Enter", style: .default) { [weak self, weak ac] _ in
            guard let textTop = ac?.textFields?[0].text else {return}
            guard let textBottom = ac?.textFields?[1].text else {return}
            
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1024, height: 1536))
            let rect =  CGRect(x: 0, y: 0, width: 1024, height: 1536).insetBy(dx: 10, dy: 10)
            let image = renderer.image { ctx in
                
                ctx.cgContext.setFillColor(UIColor.white.cgColor)
                ctx.cgContext.addRect(rect)
                ctx.cgContext.drawPath(using: .fill)
                
                photo.draw(in: CGRect(x: 0, y: 256, width: 1024, height: 1024).insetBy(dx: 10, dy: 10) )
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attributes : [NSAttributedString.Key: Any] = [
                    .font : UIFont.systemFont(ofSize: 80),
                    .foregroundColor : UIColor.black.withAlphaComponent(1),
                    .paragraphStyle : paragraphStyle
                ]
                
                let attributedStringHeader = NSAttributedString(string: textTop, attributes: attributes)
                let attributedStringFooter = NSAttributedString(string: textBottom, attributes: attributes)
                

                let headerSize = attributedStringHeader.size()
                let footerSize = attributedStringFooter.size()


                let headerX = (1024 - headerSize.width) / 2
                let footerX = (1024 - footerSize.width) / 2


                attributedStringHeader.draw(at: CGPoint(x: headerX, y: 96))
                attributedStringFooter.draw(at: CGPoint(x: footerX, y: 1344))
                
            }
            
            self?.imageView.image = image
            
        }
        
        ac.addAction(inputAction)
        present(ac, animated: true){
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.editedImage] as? UIImage else {return}
        
        dismiss(animated: true, completion: { [weak self] in
            
            self?.inputHeadeAndFooter(photo: photo)
        })
        
    }
    
    func setupView(){
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        
        ])
        
    }


}

