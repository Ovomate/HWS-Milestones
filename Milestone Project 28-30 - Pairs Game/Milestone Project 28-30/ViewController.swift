//
//  ViewController.swift
//  Milestone Project 28-30
//
//  Created by Stefan Storm on 2024/11/02.
//

import UIKit

class ViewController: UIViewController {
    
    let deckView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    var previousCard = 0
    var firstOfPair = true
    var deckButtons = [UIButton: Bool]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        title = "Pairs"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.backgroundColor = .blue
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(restartGame))
        
        setupViews()
        setupGame()
        
    }
    
    func setupViews(){
        view.addSubview(deckView)
        
        NSLayoutConstraint.activate([
            deckView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            deckView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deckView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deckView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    @objc func restartGame(){
        for view in deckView.subviews{
            view.removeFromSuperview()
        }
        setupGame()
    }

    func setupGame(){
        
        let width = view.frame.width / 4
        let height = view.frame.height / 6
        
        var deck = [1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10]
        deck.shuffle()
        
        for row in 0..<5{
            for column in 0..<4{
                
                let button = UIButton(type: .custom)
                let frame = CGRect(x: CGFloat(column) * width, y: CGFloat(row) * height, width: width, height: height).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
                button.frame = frame
                button.contentMode = .scaleAspectFit
                button.setImage(UIImage(named: "DeckBack"), for: .normal)
                button.tag = deck.removeFirst()
                button.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                
                button.layer.masksToBounds = false
                button.layer.shadowColor = UIColor.blue.cgColor
                button.layer.shadowOffset = CGSize(width: 0.0, height: 5)
                button.layer.shadowRadius = 5
                button.layer.shadowOpacity = 0.8
                
                deckView.addSubview(button)
                deckButtons[button] = false
                
            }
        }
        
    }
    
    @objc func cardTapped(_ sender: UIButton){
        
        deckButtons[sender] = true
        sender.setImage(UIImage(named: "Image\(sender.tag)"), for: .normal)
        UIView.transition(with: sender, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)

        if firstOfPair{
            sender.isUserInteractionEnabled = false
            firstOfPair = false
            previousCard = sender.tag
            return
        }else{
            setInterAction(to: false)
        }
        
        if previousCard == sender.tag{
            cardMatch(sender: sender)
            
        }else{
            cardNonMatch()
        }
        
        firstOfPair = true
        previousCard = 0
        
    }
    
    func cardMatch(sender: UIButton){
        
        for button in deckButtons.keys {
            
            if button.tag == sender.tag{
                
                UIView.animate(withDuration: 1, delay: 2, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                    button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                } completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                        button.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    }completion: { [weak self] _ in
                        button.removeFromSuperview()
                        self?.deckButtons[button] = false
                        self?.setInterAction(to: true)
                        if self?.deckView.subviews.count == 0 {
                            self?.endGame()
                        }
                    }
                }
            }
        }
    }
    
    func endGame(){
        let ac = UIAlertController(title: "You win!", message: nil, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart game?", style: .default){ [weak self] _ in
            self?.restartGame()
        }
        ac.addAction(restartAction)
        present(ac, animated: true)
    }
    
    func cardNonMatch(){
        for (button, selected) in deckButtons {
           
            if selected {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self]  in
                
                    button.setImage(UIImage(named: "DeckBack"), for: .normal)
                    UIView.transition(with: button, duration: 1, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                    self?.deckButtons[button] = false
                    self?.setInterAction(to: true)
                    
                }
            }
        }
    }
    
    func setInterAction(to enabled: Bool){
        
        for (button, _) in deckButtons {
            button.isUserInteractionEnabled = enabled
        }
        
    }
    
    

}

