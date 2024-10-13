//
//  ViewController.swift
//  Milestone Project 7-9
//
//  Created by Stefan Storm on 2024/09/14.
//

import UIKit

class ViewController: UIViewController {
    
    var triesLeftLabel: UILabel!
    var scoreLabel: UILabel!
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var imageNumber = 0 {
        didSet{
            imageView.image = UIImage(named: "Hangman-\(imageNumber)")
        }
    }
    
    var triesLeft = 6 {
        didSet{
            triesLeftLabel.text = "Tries Left: \(triesLeft)/6"
            
        }
    }
    
    var imageView: UIImageView!
    var labelsView: UIView!
    var letterLabel: UILabel!
    var buttonsView: UIView!
    var letterButtons = [UIButton]()
    var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var levelWord = ""
    var currentAnswer = [String]()
    
    
    override func loadView() {
        self.view = UIView()
        view.backgroundColor = .white
       
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadLevel()
    }

    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}

        for (index,letter) in levelWord.enumerated(){
            guard levelWord.contains(buttonTitle) else {
                wrongLetter()
                sender.isHidden = true
                 return}
            
                if String(letter) == buttonTitle {
                    currentAnswer.remove(at: index)
                    currentAnswer.insert(buttonTitle, at: index)
                }else if currentAnswer[index] != "_"{
                    //Do nothing
                }
            }
        
        if !currentAnswer.contains("_"){
            score += 1
            let ac = UIAlertController(title: "Well done!", message: "Let's play another round!" , preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { [weak self] _ in
                self?.loadLevel()
            }
            
            ac.addAction(action)
            present(ac, animated: true)
        }
        letterLabel.text = currentAnswer.joined(separator: "  ")
        sender.isHidden = true
        
    }
    
    
    func wrongLetter(){
        triesLeft -= 1
        imageNumber += 1
        
        if triesLeft == 0{
            let ac = UIAlertController(title: "Oops", message: "0 Tries left" , preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { [weak self] _ in
                self?.score = 0
                self?.loadLevel()
                
            }
            ac.addAction(action)
            present(ac, animated: true)

        }

    }

    
    func loadLevel(){
        for (index,letter) in alphabet.enumerated(){
            letterButtons[index].setTitle(String(letter), for: .normal)
        }
        triesLeft = 6
        imageNumber = 0
        for letterButton in letterButtons {
            letterButton.isHidden = false
        }
        
        DispatchQueue.global().async {
            if let levelFileURL = Bundle.main.url(forResource: "level", withExtension: "txt"){
                if let levelContents = try? String(contentsOf: levelFileURL){
                    var words = levelContents.components(separatedBy: "\n").shuffled()
                    var word = words.randomElement()?.uppercased()
                   
                    var letterString = [String]()
                    self.levelWord = word ?? "ErrorWord"
                    print(self.levelWord)
                    for (index,letter) in self.levelWord.enumerated(){
                        letterString.insert("_", at: index)
                        print(index,letter)
                    }
                    
                    self.currentAnswer = letterString
                    DispatchQueue.main.async {
                        self.letterLabel.text = letterString.joined(separator: "  ")
                    }

                }
            }
        }
    }
    
    
    func setupLayout(){
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)/6"
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
        
        triesLeftLabel = UILabel()
        triesLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        triesLeftLabel.text = "Tries Left: \(triesLeft)/6"
        triesLeftLabel.textAlignment = .center
        view.addSubview(triesLeftLabel)
        
        labelsView = UIView()
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelsView)
        
        letterLabel = UILabel()
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.font = UIFont.systemFont(ofSize: 36)
        letterLabel.numberOfLines = 0
        letterLabel.allowsDefaultTighteningForTruncation = false
        letterLabel.text = "_ A _ _ _ B _ _ _ C"
        letterLabel.textAlignment = .center
        letterLabel.adjustsFontSizeToFitWidth = false
        letterLabel.adjustsFontForContentSizeCategory = false
        labelsView.addSubview(letterLabel)

        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Hangman-0")
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        buttonsView = UIView()
        buttonsView.layer.cornerRadius = 20
        buttonsView.layer.borderColor = UIColor.black.cgColor
        buttonsView.layer.borderWidth = 1
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scoreLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            triesLeftLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            triesLeftLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            triesLeftLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            triesLeftLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            labelsView.topAnchor.constraint(equalTo: triesLeftLabel.bottomAnchor, constant: 10),
            labelsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            labelsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            labelsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            letterLabel.bottomAnchor.constraint(equalTo: labelsView.bottomAnchor),
            letterLabel.widthAnchor.constraint(equalTo: labelsView.widthAnchor),
            letterLabel.heightAnchor.constraint(equalTo: labelsView.heightAnchor, multiplier: 0.5),
            
            imageView.topAnchor.constraint(equalTo: triesLeftLabel.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: labelsView.trailingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            buttonsView.topAnchor.constraint(equalTo: labelsView.bottomAnchor,constant: 10),
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            
        ])
        let width = 47
        let height = 38
        var count = 0
        
        for row in 0..<3{
            for column in 0..<9{
                
                if count == 26 {return}
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                letterButton.setTitle("A", for: .normal)
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                count += 1
            }
        }
        
    }


}

