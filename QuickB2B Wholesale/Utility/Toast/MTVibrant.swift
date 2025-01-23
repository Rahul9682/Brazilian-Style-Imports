//
//  MotionToastView.swift
//  MotionToast
//
//  Created by Sameer Nawaz on 10/08/20.
//  Copyright © 2020 Femargent Inc. All rights reserved.

import UIKit

class MTVibrant: UIView {
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var toastView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        //circleView.layer.cornerRadius = circleView.bounds.size.width/2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: MTVibrant.self)
        let viewFromXib = bundle.loadNibNamed("MTVibrant", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func addPulseEffect() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
       // circleImg.layer.add(pulseAnimation, forKey: "animateOpacity")
    }
    
    func setupViews(toastType: ToastType) {
        switch toastType {
        case .success:
            headLabel.text = "Success"
            headLabel.textColor = .black
           // circleImg.image = UIImage(named: "success_icon")
            toastView.backgroundColor = UIColor.init(red: 255.0, green: 87.0, blue: 51.0, alpha: 1)
            break
        case .error:
            headLabel.text = "Error"
            headLabel.textColor = .black
           // circleImg.image = UIImage(named: "error_icon")
            toastView.backgroundColor = UIColor.init(red: 255.0, green: 87.0, blue: 51.0, alpha: 1)
            break
        case .warning:
            headLabel.text = "Warning"
            headLabel.textColor = .black
           // circleImg.image = UIImage(named: "warning_icon")
            toastView.backgroundColor = UIColor.init(red: 255.0, green: 87.0, blue: 51.0, alpha: 1)
            break
        case .info:
            headLabel.text = "Info"
            headLabel.textColor = .black
           // circleImg.image = UIImage(named: "info_icon")
            toastView.backgroundColor = UIColor.init(red: 255.0, green: 87.0, blue: 51.0, alpha: 1)
            break
        }
    }
}
