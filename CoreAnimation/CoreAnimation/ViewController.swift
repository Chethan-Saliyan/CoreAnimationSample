//
//  ViewController.swift
//  CoreAnimation
//
//  Created by Chethan on 25/07/19.
//  Copyright © 2019 Chethan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient:Int = 0
    let colorOne = UIColor.blue.cgColor
    let colorTwo = UIColor.red.cgColor
    let colorThree = UIColor.yellow.cgColor
    
    @IBOutlet weak var countdownProgressBar: CountDownProgressorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
         view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
             createGradientView()
    }
    
    @objc func handleTap() {
        print("Tapped")
        
        countdownProgressBar.startCoundown(duration: 10, showPulse: true)
    }

    private func createGradientView() {
        gradientSet.append([colorOne,colorTwo])
        gradientSet.append([colorTwo,colorThree])
        gradientSet.append([colorThree,colorOne])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.drawsAsynchronously = true
        self.view.layer.insertSublayer(gradient, at: 0)
        animateGradient()
    }

    private func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        }
        else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
    }
}

extension ViewController:CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

