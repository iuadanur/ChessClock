//
//  ViewController.swift
//  ChessClock
//
//  Created by İbrahim Utku Adanur on 9.03.2024.
//

import UIKit
import SwiftAlertView

class TimerVC: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var middleBar: UIView!
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var clockButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    
    var isPaused = false
    var isMuted = false
    
    var timer1 = Timer()
    var timer2 = Timer()
        
    var counter1 = 0
    var counter1S = 60
        
    var plus = 0
        
    var counter2 = 0
    var counter2S = 60
    
    var isTurnFirstUser: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        firstLabel.text = "\(counter1+1):0"
        secondLabel.text = "\(counter2+1):0"
        
        customizeButtons()
        firstView.isUserInteractionEnabled = true
        secondView.isUserInteractionEnabled = true
        
        let gr1 = UITapGestureRecognizer(target: self, action: #selector(GR1))
                firstView.addGestureRecognizer(gr1)
        let gr2 = UITapGestureRecognizer(target: self, action: #selector(GR2))
                secondView.addGestureRecognizer(gr2)
    }
    @objc func firstTimer() {
           
           counter1S -= 1
           firstLabel.text = "\(counter1):\(counter1S)"
           
           if counter1S == 0 {
               counter1S = 60
               
               if counter1 == 0 {
                   timer1.invalidate()
               }else{
                   counter1 -= 1
               }
               
           }
    }
    
    @objc func secondTimer() {
           counter2S -= 1
           secondLabel.text = "\(counter2):\(counter2S)"
           
           if counter2S == 0 {
               counter2S = 60
               
               if counter2 == 0 {
                   timer2.invalidate()
               }else{
                   counter2 -= 1
               }
               
           }
    }
    
    @objc func GR1() {
        pauseButton.isHidden = false
        secondView.isUserInteractionEnabled = true
        firstView.isUserInteractionEnabled = false
        
        timer1.invalidate()
                
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondTimer), userInfo: nil, repeats: true)
        
        isTurnFirstUser = false
        
        firstView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0))
        secondView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0))
        secondLabel.textColor = UIColor.white
        firstLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0))
    }
    @objc func GR2() {
        pauseButton.isHidden = false
        firstView.isUserInteractionEnabled = true
        secondView.isUserInteractionEnabled = false
        
        isTurnFirstUser = true
        
        secondView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)) //GRAY
        firstView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)) //GREEN
        firstLabel.textColor = UIColor.white
        secondLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)) //Making gray again

        timer2.invalidate()
                
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(firstTimer), userInfo: nil, repeats: true)
    }
    func customizeButtons() {
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        restartButton.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: configuration), for: .normal)
        pauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: configuration), for: .normal)
        clockButton.setImage(UIImage(systemName: "clock", withConfiguration: configuration), for: .normal)
        soundButton.setImage(UIImage(systemName: "speaker.wave.2", withConfiguration: configuration), for: .normal)
        pauseButton.isHidden = true
    }
    
    func pauseTimers() {
        timer1.invalidate()
        timer2.invalidate()
    }

    func resumeTimers() {
        if !isPaused {
            timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(firstTimer), userInfo: nil, repeats: true)
            timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondTimer), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func restartButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Clock", message: nil, preferredStyle: .actionSheet)
        
//        let subview = alert.view.subviews.first! as UIView
//        let alertContentView = subview.subviews.first! as UIView
//        alertContentView.backgroundColor = UIColor.black
        
//        alert.view.tintColor = .darkText
//        alert.view.backgroundColor = UIColor.black
        
//        SwiftAlertView.show(title: "Reset Clock",
//                            message: nil,
//                            buttonTitles: "OK", "Cancel") { alert in
//            alert.titleLabel.textColor = .white
//            alert.backgroundColor = .black
//            alert.buttonTitleColor = .white
//            alert.isDismissOnOutsideTapped = true
//        }
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                 
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
        isPaused.toggle()
        if isPaused {
            pauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
            if isTurnFirstUser == true {
                timer1.invalidate()
                firstView.isUserInteractionEnabled = false
                firstView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0))
                firstLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0))
            } else {
                timer2.invalidate()
                secondView.isUserInteractionEnabled = false
                secondView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0))
                secondLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0))
            }
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
            if isTurnFirstUser == true {
                timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(firstTimer), userInfo: nil, repeats: true)
                firstView.isUserInteractionEnabled = true
                firstView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)) //GREEN
                firstLabel.textColor = UIColor.white
            } else {
                timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondTimer), userInfo: nil, repeats: true)
                secondView.isUserInteractionEnabled = true
                secondView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0))
                secondLabel.textColor = UIColor.white
            }
        }
    }
    
    @IBAction func clockButtonClicked(_ sender: Any) {
    }
    
    @IBAction func soundButtonClicked(_ sender: Any) {
        isMuted.toggle()
        if isMuted {
            soundButton.setImage(UIImage(systemName: "speaker.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker.wave.2", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)        }
    }
    
    
    
}

