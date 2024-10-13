//
//  ViewController.swift
//  Milestone Project 1-3
//
//  Created by Stefan Storm on 2024/08/28.
//

import UIKit

class ViewController: UITableViewController {
    
    var flagPictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.black
        
        
        flagPictures += ["estonia", "france", "germany","ireland","italy","monaco","nigeria",
                      "poland","russia","spain","uk","us"]
        
//        let fm = FileManager.default
//        let path = Bundle.main.resourcePath!
//        let items = try! fm.contentsOfDirectory(atPath: path)
        
//        for item in items {
//            if item.hasSuffix("png"){
//                flagPictures.append(item)
//            }
//            
//        }
//        print(flagPictures)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagPictures.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text? = flagPictures[indexPath.row].localizedCapitalized
        cell.imageView?.image = UIImage(named: flagPictures[indexPath.row])
        cell.imageView?.layer.borderWidth = 0.5
        
        return cell
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as?
            DetailViewController{
            vc.selectedFlag = flagPictures[indexPath.row]
           // vc.selectedIndex = indexPath.row
          //  vc.pictureArray = pictures
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

