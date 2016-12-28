//
//  RoundImageView.swift
//  FMJP
//
//  Created by yesway on 2016/12/23.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
        
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).cgColor
    }
    
    func rotation() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = M_PI * 2
        animation.duration = 20
        animation.repeatCount = 1000
        self.layer.add(animation, forKey: nil)
        
    }
}
