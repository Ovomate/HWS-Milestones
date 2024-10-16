import UIKit
import PlaygroundSupport

//MARK: Challenge 1 - Make a view bounce in and out

let viewRed : UIView = {
   let view = UIView()
    view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100))
    view.backgroundColor = .red
    view.layer.cornerRadius = 5
    return view
}()


extension UIView {
    func bounceInOut(duration: TimeInterval){
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5){ [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            DispatchQueue.main.asyncAfter(deadline: .now()){
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5){
                    self?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }

    }
    
}

PlaygroundPage.current.setLiveView(viewRed)
viewRed.bounceInOut(duration: 2)

//MARK: Challenge 2: Extend Int with a times() method that runs a closure as many times as the number is high.

let testNumber = 10
let testNumberZero = 0

extension Int {
    func times(_ closure: () -> Void) {
        guard self != 0 else {return}
        for i in 1...self {
            closure()
        }
    }
}

testNumber.times {
    print("Printed10")
}
testNumberZero.times {
    print("PrintedZero")
}

//MARK: Challenge 3: Extend Array so that it has a mutating remove(item:) method. If the item exists more than once

var testArray = ["Cat", "Dog", "Cow", "Donkey", "Hamster"]

extension Array where Element: Comparable {
    mutating func remove(item: Element ) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

testArray.remove(item: "Dog")

