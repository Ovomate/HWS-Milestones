//
//  ViewController.swift
//  Milestone Project 10-12 - Photo Album
//
//  Created by Stefan Storm on 2024/09/23.
//

//TODO: Done

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    
    let cellId = "cellId"
    var photos = [Photo]()
    let defaults = UserDefaults.standard
    
    lazy var photoCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 20
        cv.allowsMultipleSelection = false
        cv.bounces = true
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10 )
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        navigationItem.title = "Photo Album"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        setupLayout()
        loadPhotos()
        
    }
    
    
    @objc func editButtonTapped(_ sender: UIButton){
        let photo = photos[sender.tag]


        let ac = UIAlertController(title: "Edit Photo:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let addAction = UIAlertAction(title: "Edit caption", style: .default){ [weak self, weak ac] _ in
            guard let newCaption = ac?.textFields?[0].text else {return}
            
            photo.caption = newCaption
            self?.savePhotos()
            self?.photoCollectionView.reloadData()
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default){ [weak self] _ in
            self?.photos.remove(at: sender.tag)
            self?.savePhotos()
            self?.photoCollectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(addAction)
        ac.addAction(cancelAction)
        ac.addAction(deleteAction)
        present(ac, animated: true)
    }
    
    
    func loadPhotos(){
        if let savedPhotos = self.defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do{
                self.photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)

            }catch{
                print("Failed")
            }

        }
    }
    
    
    @objc func addNewPhoto(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self

        let ac = UIAlertController(title: "Please choose available source:", message: nil, preferredStyle: .alert)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default){  [weak self] _ in
                picker.sourceType = .camera
                self?.present(picker,animated: true)
            }
            ac.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default){ [weak self] _ in
            picker.sourceType = .photoLibrary
            self?.present(picker,animated: true)
        }
        
        ac.addAction(libraryAction)
        present(ac, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.editedImage ] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(image: imageName, caption: "Unknown")
        photos.append(photo)
        savePhotos()
        photoCollectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        return paths[0]
    }
    
    
    func savePhotos(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(photos){
            defaults.set(savedData, forKey: "photos")
        }else{
            print("Save failure")
        }
    }
    
    
    func setupLayout(){

        view.addSubview(photoCollectionView)
        
        if let flowLayout = photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .vertical
            //Fix gap for horizontal scroll gap.
            flowLayout.minimumLineSpacing = 10
        }
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            
            ])
    }
    
    
    
    //MARK: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.selectedImage = photos[indexPath.item].image
        print(indexPath.item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoCollectionView.frame.width - 20, height: photoCollectionView.frame.height / 8)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoCell else {fatalError()}
        let photo = photos[indexPath.item]
        cell.captionLabel.text = photo.caption
        cell.editButton.tag = indexPath.item
        cell.editButton.addTarget(self, action:  #selector(self.editButtonTapped), for: .touchUpInside)
     //   cell.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        return cell
    }


}

