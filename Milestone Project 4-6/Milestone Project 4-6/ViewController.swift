//
//  ViewController.swift
//  Milestone Project 4-6
//
//  Created by Stefan Storm on 2024/09/05.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        title = "Shopping list"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
  
        navigationItem.rightBarButtonItems = [share, add]

        
        
    }
    
    @objc func shareTapped(){
        
        let list = shoppingList.joined(separator: "\n")

        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func addItem(){
        let ac = UIAlertController(title: "Add your item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else {return}
            guard !item.isEmpty else {
                let ac = UIAlertController(title: "Duhh", message: "🙈🙈🙈", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self?.present(ac, animated: true)
                return}
            
            self?.shoppingList.insert(item, at: 0)
            let indexPath = IndexPath(row: 0, section:  0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            self?.tableView.becomeFirstResponder()
        }
        ac.addAction(addAction)
        present(ac, animated: true)
        
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
          //  toggleButton(toggle: false, alpha: 0, image: "plus")
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }


}

