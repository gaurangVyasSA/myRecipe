//
//  UIViewController.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 30/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit

extension UIViewController {
    
     func presentInputAlertView(title:String, actionHandler: @escaping (_ text:String)->Void){
        let alertView = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertView.addTextField { (textfield) in
            
        }
        alertView.addAction(UIAlertAction(title: Strings.cancel, style: .cancel))
        alertView.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: { [weak alertView] (action) in
            actionHandler(alertView?.textFields?.first?.text ?? "")
        }))
        present(alertView, animated: true)
    }
}
