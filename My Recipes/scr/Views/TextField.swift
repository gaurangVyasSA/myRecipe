//
//  TextField.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit

@IBDesignable
class TextField: UITextField {
    
    func setup() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1/UIScreen.main.scale
        clipsToBounds = true
        tintColor = UIColor.primaryColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup() 
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: 40)
    }
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
