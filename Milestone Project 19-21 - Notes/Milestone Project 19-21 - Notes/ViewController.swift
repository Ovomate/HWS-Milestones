//
//  ViewController.swift
//  Milestone Project 19-21 - Notes
//
//  Created by Stefan Storm on 2024/10/12.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var cellID = "cellID"
    var notes = [Note]()
    var dataModel = DataModel()
    
    lazy var notesTableview: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .plain)
        tv.register(NotesCell.self, forCellReuseIdentifier: cellID)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .black
        return tv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let newNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNoteTapped))
        toolbarItems = [flexibleSpace, newNote]
        navigationController?.isToolbarHidden = false
        
        setupViewController()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        notes = dataModel.retrieveNotes()
        notesTableview.reloadData()
    }
    
    
    @objc func newNoteTapped(){
        let vc = DetailViewController()
        vc.newNote = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupViewController(){
        view.addSubview(notesTableview)
        
        NSLayoutConstraint.activate([
        notesTableview.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        notesTableview.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        notesTableview.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        notesTableview.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)

        ])
        
    }
    
    
    //MARK: Tableview Methods
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            dataModel.saveNotes(notes)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? NotesCell else{fatalError()}
        let note = notes[indexPath.row]
        cell.noteTitle.text = note.title
        cell.noteContent.text = note.content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let vc = DetailViewController()
        vc.selectedTitle = note.title
        vc.selectedContent = note.content
        vc.indexNumber = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }


}

