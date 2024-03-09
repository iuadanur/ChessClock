//
//  ViewController.swift
//  ChessClock
//
//  Created by İbrahim Utku Adanur on 9.03.2024.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        customizeButtons()
        firstView.isUserInteractionEnabled = true
        secondView.isUserInteractionEnabled = true
        
        let gr1 = UITapGestureRecognizer(target: self, action: #selector(GR1))
                firstView.addGestureRecognizer(gr1)
        let gr2 = UITapGestureRecognizer(target: self, action: #selector(GR2))
                secondView.addGestureRecognizer(gr2)
    }
    @objc func GR1() {
        secondView.isUserInteractionEnabled = true
        firstView.isUserInteractionEnabled = false
        
        
    }
    @objc func GR2() {
        firstView.isUserInteractionEnabled = true
        secondView.isUserInteractionEnabled = false
        
    }
    func customizeButtons() {
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        restartButton.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: configuration), for: .normal)
        pauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: configuration), for: .normal)
        clockButton.setImage(UIImage(systemName: "clock", withConfiguration: configuration), for: .normal)
        soundButton.setImage(UIImage(systemName: "speaker.wave.2", withConfiguration: configuration), for: .normal)
    }
    
    @IBAction func restartButtonClicked(_ sender: Any) {
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
    }
    
    @IBAction func clockButtonClicked(_ sender: Any) {
    }
    
    @IBAction func soundButtonClicked(_ sender: Any) {
    }
    
    
    
}

