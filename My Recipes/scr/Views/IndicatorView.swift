//
//  IndicatorView.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import NVActivityIndicatorView

class IndicatorView:UIView{
    
    let indicator = NVActivityIndicatorView(frame: .zero)
    
    convenience init(view: UIView) {
        self.init()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        isHidden = true
        indicator.type = .ballPulse
        indicator.color = UIColor.primaryColor
        indicator.stopAnimating()
    }
    
    func startAnimation(){
        isHidden = false
        indicator.startAnimating()
    }
    
    func stopAnimation(){
        isHidden = true
        indicator.stopAnimating()
    }
    
    
}
