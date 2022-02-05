//
//  UIViewExtension.swift
//  ContactDetails
//
//  Created by Dhaval Rajani on 05/02/22.
//

import UIKit

extension UIView {
  func addLinearGradient(colors: [CGColor] = [UIColor.white.cgColor, UIColor.clear.cgColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0), locations: [NSNumber] = [0.0, 1.0]) {
    guard bounds.size.height > 0 && bounds.size.width > 0 else { return }
    let gradientView = UIView(frame: self.bounds)
    gradientView.tag = 999
    let gradient = CAGradientLayer()
    gradient.frame = gradientView.frame
    gradient.colors = colors
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    gradient.locations = locations
    gradientView.layer.insertSublayer(gradient, at: 0)
    removeLinearGradient()
    self.addSubview(gradientView)
  }
  
  func removeLinearGradient() {
    self.subviews.filter( {$0.tag == 999} ).forEach( {$0.removeFromSuperview()} )
  }
}
