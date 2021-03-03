//
//  UIViewExtension.swift
//  Weather
//
//  Created by Макс Пайдич on 02.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor?  {
        get {
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) :  nil
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func setupGradientLayer() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        let topColor = UIColor.lightBlue.cgColor
        let bottomColor = UIColor.lightPurple.cgColor
        
        gradientLayer.colors = [topColor,bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.frame
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}