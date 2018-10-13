import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!

    var hud: MBProgressHUD?
    var score: Int = 0
    var timer: Timer?
    var gameTime: Int = 60

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
        
        // this allows to set timer at the beginning of the game and don't reset it every time when new answer is given, it will be set to nil at end of the game
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onUpdateTimer), userInfo: nil, repeats: true)
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
    
    func updateTimeLabel() {
        if timerLabel != nil {
            let min: Int = (gameTime / 60) % 60
            let sec: Int = gameTime % 60
            
            let min_p: String = String(format: "%02d", min)
            let sec_p: String = String(format: "%02d", sec)
            
            timerLabel.text = "\(min_p):\(sec_p)"
        }
    }
    
    @objc func onUpdateTimer() {
        
        if gameTime > 0 && gameTime <= 60 {
            gameTime -= 1
            updateTimeLabel()
        } else if gameTime == 0 {
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    

}
