import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    var hud: MBProgressHUD?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!

    // score variable
    var score: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        updateScoreLabel()
        updateNumberLabel()
        
        // why this should be in viewDidLoad?
        inputField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        hud = MBProgressHUD(view: self.view)
        if hud != nil {
            self.view.addSubview(hud!)
        }
        
    }
    
    func generateRandomNumber() -> String {
        var result = ""
        for _ in 1...4 {
            let number = arc4random_uniform(8) + 1
            result += String(number)
        }
        return result
    }
    
    func updateScoreLabel() {
       scoreLabel.text = String(score)
    }
    
    func updateNumberLabel() {
        numberLabel.text = generateRandomNumber()
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if (inputField.text?.count ?? 0) < 4 {
            return
        }
        
        if let stringNumber = numberLabel.text,
            let randomNumber = Int(stringNumber),
            let stringInput = inputField.text,
            let inputNumber = Int(stringInput) {
            
            print("Comparing: \(inputNumber) - \(randomNumber) = \(inputNumber - randomNumber)")
            
            if inputNumber - randomNumber == 1111 {
                print("Correct!")
                showHUDWithAnswer(isRight: true)
                score += 1
            } else {
                print("Wrong!")
                showHUDWithAnswer(isRight: false)
                score -= 1
            }
        }
        updateNumberLabel()
        updateScoreLabel()
    }
    
    func showHUDWithAnswer(isRight: Bool) {
        
        var imageView: UIImageView?
        
        if isRight {
            imageView = UIImageView(image: UIImage(named: "thumbs-up"))
        } else {
            imageView = UIImageView(image: UIImage(named: "thumbs-down"))
        }
        
        if imageView != nil {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            
            hud?.show(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hud?.hide(animated: true)
                self.inputField.text = ""
            }
        }
    }
    

}
