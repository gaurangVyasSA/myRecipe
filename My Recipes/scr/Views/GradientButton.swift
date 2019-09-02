//
//  GradientButton.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    
    let gradientColors : [UIColor] = [UIColor.primaryColor, UIColor.primaryDarkColor]
    let startPoint = CGPoint(x: 0, y: 0.5)
    let endPoint = CGPoint(x: 1, y: 0.5)
    
  
    func setup(){
        setTitleColor(.white, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let halfOfButtonHeight = layer.frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 10, left: halfOfButtonHeight, bottom: 10, right: halfOfButtonHeight)
        
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        backgroundColor = UIColor.clear
        
        // setup gradient
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = halfOfButtonHeight
        
        // replace gradient as needed
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradient)
        } else {
            layer.insertSublayer(gradient, below: nil)
        }
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
            let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: 40)
    }
}
