//
//  ViewController.swift
//  ChessClock
//
//  Created by İbrahim Utku Adanur on 9.03.2024.
//

import UIKit
import SwiftAlertView
import AVFoundation

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
    
    @IBOutlet weak var firstViewMovesLabel: UILabel!
    @IBOutlet weak var secondViewMovesLabel: UILabel!
    
    @IBOutlet weak var firstSettingsButton: UIButton!
    @IBOutlet weak var secondSettingsButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    
    var isPaused = false
    var isMuted = false
    
    var timer1 = Timer()
    var timer2 = Timer()
        
    var counter1 = 0
    var counter1S = 5
        
    var plus = 0
        
    var counter2 = 0
    var counter2S = 5
    
    var isTurnFirstUser: Bool?
    var isFirstMove = true
    
    var movesCountFirst = 0
    var movesCountSecond = 0
    
    var firstButtonTopConstraint: NSLayoutConstraint!
    var secondButtonBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let sliderImage = UIImage(systemName: "slider.horizontal.3", withConfiguration: largeConfig)

        firstSettingsButton.setImage(sliderImage, for: .normal)
        secondSettingsButton.setImage(sliderImage, for: .normal)
        firstSettingsButton.tintColor = UIColor(cgColor: CGColor(red: 35.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0))
        secondSettingsButton.tintColor = UIColor(cgColor: CGColor(red: 35.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0))
        
        firstSettingsButton.transform = CGAffineTransform(rotationAngle: .pi)
        firstViewMovesLabel.transform = CGAffineTransform(rotationAngle: .pi)
        firstLabel.transform = CGAffineTransform(rotationAngle: .pi)
        firstLabel.text = "\(counter1+1):0"
        secondLabel.text = "\(counter2+1):0"
        
        customizeButtons()
        firstView.isUserInteractionEnabled = true
        secondView.isUserInteractionEnabled = true
        
        firstViewMovesLabel.text = "Moves:\(movesCountFirst)"
        secondViewMovesLabel.text = "Moves:\(movesCountSecond)"
        
        let gr1 = UITapGestureRecognizer(target: self, action: #selector(GR1))
                firstView.addGestureRecognizer(gr1)
        let gr2 = UITapGestureRecognizer(target: self, action: #selector(GR2))
                secondView.addGestureRecognizer(gr2)
        
        firstButtonTopConstraint = firstSettingsButton.topAnchor.constraint(equalTo: firstView.topAnchor, constant: -400)
        secondButtonBottomConstraint = secondSettingsButton.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: 400)
        //Set active the constraints
        NSLayoutConstraint.activate([
            firstButtonTopConstraint,
            secondButtonBottomConstraint
        ])

    }
    func playMoveSound(name: String) {
        if isMuted { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Ses çalarken bir hata oluştu: \(error)")
        }
    }
    
    func animateButtonsIn() {
        UIView.animate(withDuration: 0.3) {
            self.firstButtonTopConstraint.constant = 95
            self.secondButtonBottomConstraint.constant = -95
            self.view.layoutIfNeeded()
        }
    }
    
    func animateButtonsOut() {
        UIView.animate(withDuration: 0.3) {
            self.firstButtonTopConstraint.constant = -400
            self.secondButtonBottomConstraint.constant = 400
            self.view.layoutIfNeeded()
        }
    }

    @objc func firstTimer() {
           
           counter1S -= 1
           firstLabel.text = "\(counter1):\(counter1S)"
           
           if counter1S == 0 {
               counter1S = 60
               
               if counter1 == 0 {
                   timer1.invalidate()
                   
                   firstView.backgroundColor = UIColor.red
                   firstLabel.textColor = UIColor.white
                   
                   firstView.isUserInteractionEnabled = false
                   pauseButton.isUserInteractionEnabled = false
                   
                   playMoveSound(name: "gameEnded")
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
                   
                   secondView.backgroundColor = UIColor.red
                   secondLabel.textColor = UIColor.white
                   
                   secondView.isUserInteractionEnabled = false
                   pauseButton.isUserInteractionEnabled = false
                   
                   playMoveSound(name: "gameEnded")
               }else{
                   counter2 -= 1
               }
               
           }
    }
    func GR1Helper() {
        if isPaused {
            pauseButtonClickedHelper()
        }
    }
    @objc func GR1() {
        guard movesCountFirst <= movesCountSecond else {GR1Helper(); return}
        firstView.isUserInteractionEnabled = false
        if !isFirstMove {
            if isPaused {
               pauseButtonClickedHelper()
                return
            }
        }
        pauseButton.isHidden = false
        secondView.isUserInteractionEnabled = true
//        firstView.isUserInteractionEnabled = false
        
        timer1.invalidate()
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondTimer), userInfo: nil, repeats: true)
        
        isTurnFirstUser = false
        if isFirstMove {
            isFirstMove = false
        } else {
            movesCountFirst += 1
            updateCountLabel()
            playMoveSound(name: "player1")
        }
        firstView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0))
        secondView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0))
        secondLabel.textColor = UIColor.white
        firstLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0))
    }
    func GR2Helper() {
        if isPaused {
            pauseButtonClickedHelper()
        }
    }
    @objc func GR2() {
        guard movesCountSecond <= movesCountFirst else {
            GR2Helper(); return}
        secondView.isUserInteractionEnabled = false
        if !isFirstMove {
            if isPaused {
                
                pauseButtonClickedHelper()
                return
            }
        }
        pauseButton.isHidden = false
        firstView.isUserInteractionEnabled = true
//        secondView.isUserInteractionEnabled = false
        
        isTurnFirstUser = true
        
        if isFirstMove {
            isFirstMove = false
        } else {
            movesCountSecond += 1
            updateCountLabel()
            playMoveSound(name: "player2")
        }
        
        secondView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)) //GRAY
        firstView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)) //GREEN
        firstLabel.textColor = UIColor.white
        secondLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)) //Making gray again

        timer2.invalidate()
                
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(firstTimer), userInfo: nil, repeats: true)
    }
    
    func updateCountLabel() {
        firstViewMovesLabel.text = "Moves:\(movesCountFirst)"
        secondViewMovesLabel.text = "Moves:\(movesCountSecond)"
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
    func pauseButtonClickedHelper() {
        isPaused.toggle()
        if isPaused {
            animateButtonsIn()
            pauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
            if isTurnFirstUser == true {
                timer1.invalidate()
                
                firstView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0))
                firstLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0))
                secondView.isUserInteractionEnabled = true
            } else {
                timer2.invalidate()
                
                secondView.backgroundColor = UIColor(cgColor: CGColor(red: 138.0 / 255.0, green: 137.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0))
                secondLabel.textColor = UIColor(cgColor: CGColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0))
                firstView.isUserInteractionEnabled = true

            }
        } else {
            animateButtonsOut()
            pauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
            if isTurnFirstUser == true {
                timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(firstTimer), userInfo: nil, repeats: true)
                
                firstView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)) //GREEN
                firstLabel.textColor = UIColor.white
                firstView.isUserInteractionEnabled = true
            } else {
                timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondTimer), userInfo: nil, repeats: true)
                
                secondView.backgroundColor = UIColor(cgColor: CGColor(red: 128.0 / 255.0, green: 182.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0))
                secondLabel.textColor = UIColor.white
                secondView.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func restartButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Reset Clock", message: nil, preferredStyle: .actionSheet)

        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive, handler: {action in})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in})
       
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func pauseButtonClicked(_ sender: Any) {
        pauseButtonClickedHelper()
    }
    
    @IBAction func clockButtonClicked(_ sender: Any) {
    }
    
    @IBAction func soundButtonClicked(_ sender: Any) {
        isMuted.toggle()
        if isMuted {
            soundButton.setImage(UIImage(systemName: "speaker.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
            audioPlayer?.stop()
        } else {
            soundButton.setImage(UIImage(systemName: "speaker.wave.2", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)        }
    }
    
    @IBAction func firstSettingButtonClicked(_ sender: Any) {
        print("asd1")
    }
    
    @IBAction func secondSettingButtonClicked(_ sender: Any) {
        print("asd2")
    }
    
}

