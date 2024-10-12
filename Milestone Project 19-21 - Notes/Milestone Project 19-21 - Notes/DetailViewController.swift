//
//  DetailViewController.swift
//  Milestone Project 19-21 - Notes
//
//  Created by Stefan Storm on 2024/10/12.
//

import UIKit

class DetailViewController: UIViewController {
    
    var newNote = false
    var selectedTitle = ""
    var selectedContent = ""
    var notes = [Note]()
    var indexNumber : Int?
    let defaults = UserDefaults.standard
    var dataModel = DataModel()
    
    let textView : UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Arial Black", size: 20)
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.textAlignment = .left
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 33.0/255, green: 33.0/255, blue: 33/255, alpha: 1)
        view.layer.cornerRadius = 8
        view.tintColor = UIColor(red: 255/255, green: 190/255, blue: 0/255, alpha: 1)
        return view
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        
        textView.becomeFirstResponder()
        title = selectedTitle
        textView.text = selectedContent
        notes = dataModel.retrieveNotes()
    
        setupDetailViewController()
    }
    
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    
    @objc func shareTapped(){
        
        if let shareText = textView.text {
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
            
        }
        

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        guard textView.text != "" else {return}
        
        let str = textView.text.components(separatedBy: " ").first
        
        if !newNote{
            if let num = indexNumber {
                notes.remove(at: num)
                notes.insert(Note(title: str ?? "No title", content: textView.text), at: num)
            }
        }else{
            notes.append(Note(title: str ?? "No title", content: textView.text))
        }
        dataModel.saveNotes(notes)
        
    }
    
    
    func setupDetailViewController(){
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            
        ])
    }
    
}
