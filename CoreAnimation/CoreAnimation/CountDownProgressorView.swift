//
//  CountDownProgressorView.swift
//  CoreAnimation
//
//  Created by Chethan on 25/07/19.
//  Copyright © 2019 Chethan. All rights reserved.
//

import UIKit

class CountDownProgressorView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var timer = Timer()
    private var duration = 5.0
    private var remainingTime = 0.0
    private var showPulse = false
    private lazy var remainingTimeLabel : UILabel = {
        let remainingTimeLabel: UILabel = UILabel.init(frame: CGRect.init(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: bounds.width, height: bounds.height)))
        remainingTimeLabel.font   = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        remainingTimeLabel.textAlignment = .center
        return remainingTimeLabel
    }()
    
    //foreground layer that is animated
    private lazy var foregroundLayer: CAShapeLayer = {
        let foregroundLayer = CAShapeLayer()
        foregroundLayer.lineWidth = 10
        foregroundLayer.strokeColor = UIColor.white.cgColor
        foregroundLayer.lineCap = .round
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeEnd = 0
        foregroundLayer.frame = bounds
        return foregroundLayer
    }()
    
    //background layer that show gray path
    private lazy var backgroundLayer: CAShapeLayer = {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineWidth = 10
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.frame = bounds
        return backgroundLayer
    }()
    
    //layer that is used to get pulsing animation
    private lazy var pulseLayer: CAShapeLayer = {
        let pulseLayer = CAShapeLayer()
        pulseLayer.lineWidth = 10
        pulseLayer.strokeColor = UIColor.lightGray.cgColor
        pulseLayer.lineCap = .round
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.frame = bounds
        return pulseLayer
    }()
    
    private lazy var foregroundDradientLayer: CAGradientLayer = {
        let foregroundGradientLayer = CAGradientLayer()
        foregroundGradientLayer.frame = bounds
        let startColor = UIColor.red.cgColor
        let secondColor = UIColor.yellow.cgColor
        foregroundGradientLayer.colors = [startColor, secondColor]
        foregroundGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        foregroundGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return foregroundGradientLayer
    }()
    
    private lazy var puseGradientLayer: CAGradientLayer = {
         let puseGradientLayer = CAGradientLayer()
        puseGradientLayer.frame = bounds
        let startColor = UIColor.red.cgColor
        let secondColor = UIColor.yellow.cgColor
        puseGradientLayer.colors = [startColor, secondColor]
        puseGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        puseGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return puseGradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadLayers()
//        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadLayers() {
        self.backgroundColor = UIColor.clear
        let centerPoint = CGPoint(x: frame.width/2, y: frame.height/2)
        //create circular path that is just slightly smaller than the view
        //set starting angle to be 12 o'clock and ending angle 360 degree clock wise
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width/2-20, startAngle: -CGFloat.pi/2, endAngle: (2 * CGFloat.pi) -  CGFloat.pi/2 , clockwise: true)
        //give the CAShapeLayers the circular path to follow
        //pulse and foreground layers will be the masks over the gradient layers
        //and the background CAShapeLayer and the 2 CAGradientLayer as a sublayer
        pulseLayer.path = circularPath.cgPath
        puseGradientLayer.mask = pulseLayer
        layer.addSublayer(puseGradientLayer)
        backgroundLayer.path = circularPath.cgPath
        layer.addSublayer(backgroundLayer)
        foregroundLayer.path = circularPath.cgPath
        foregroundDradientLayer.mask = foregroundLayer
        layer.addSublayer(foregroundDradientLayer)
        addSubview(remainingTimeLabel)
    }
    
    private func animateForegroundLayer() {
        let foregroundAnimation = CABasicAnimation(keyPath: "strokeEnd")
        foregroundAnimation.fromValue = 0
        foregroundAnimation.toValue = 1
        foregroundAnimation.duration = CFTimeInterval(duration)
        foregroundAnimation.fillMode = CAMediaTimingFillMode.both
        foregroundAnimation.isRemovedOnCompletion = false
        foregroundAnimation.delegate = self
        foregroundLayer.add(foregroundAnimation, forKey: nil)//"foregroundAnimation"
    }
    
    private func animatePulseLayer() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue =  1.0
        pulseAnimation.toValue = 1.2
        let pulseOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        pulseOpacityAnimation.fromValue = 0.7
        pulseOpacityAnimation.toValue = 0.0
        let groupedAnimation = CAAnimationGroup()
        groupedAnimation.animations = [pulseAnimation, pulseOpacityAnimation]
        groupedAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        groupedAnimation.duration = 1.0
        groupedAnimation.repeatCount = Float.infinity
        pulseLayer.add(groupedAnimation, forKey: nil)//"pulseAnimation"
    }
    
    /**
     Stars the countdown with defined duration.
     
     - Parameter duration: Countdown time duration.
     - Parameter showPulse: By default false, set to true to show pulse around the countdown progress bar.
     
     - Returns: null.
     */
    
    func startCoundown(duration: Double, showPulse: Bool = false) {
        self.duration = duration
        self.showPulse = showPulse
        remainingTime = duration
        remainingTimeLabel.text = "\(remainingTime)"
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimerTick), userInfo: nil, repeats: true)
        beginAnimation()
        
    }
    
    private func beginAnimation() {
        
        animateForegroundLayer()
        
        // only show the pulse if required
        if showPulse {
            animatePulseLayer()
        }
        
    }
    
    @objc private func handleTimerTick() {
        remainingTime -= 0.1
        if remainingTime > 0 {
            
        }
        else {
            remainingTime = 0
            timer.invalidate()
        }
        
        DispatchQueue.main.async {
            self.remainingTimeLabel.text = "\(String.init(format: "%.1f", self.remainingTime))"
        }
    }
    
    deinit {
        timer.invalidate()
    }
    
}

extension CountDownProgressorView:  CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        pulseLayer.removeAllAnimations()
        timer.invalidate()
    }
}
