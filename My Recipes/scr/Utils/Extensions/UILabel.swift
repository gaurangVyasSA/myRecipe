//
//  File.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit

extension UILabel{
    
    func setSmallGrayStyle() {
        font = UIFont.systemFont(ofSize: 14)
        textColor = .lightGray
    }
    
    func setSectionHeaderStyle(){
        font = UIFont.systemFont(ofSize: 14)
        textColor = .black
        textAlignment = .center
        backgroundColor = .groupTableViewBackground
    }
    
    func setTextLabelStyle(){
        font = UIFont.systemFont(ofSize: 17)
        textColor = .black
    }
    
    func setAttributedText(icon: UIImage, text: String) {
        let attributedString = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: (font.capHeight - icon.size.height).rounded() / 2, width: icon.size.width, height: icon.size.height)
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string:" " + text))
        self.attributedText = attributedString
    }
    
}
