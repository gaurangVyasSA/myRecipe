//
//  AppDelegate.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = UIColor.primaryColor
        IQKeyboardManager.shared.enable = true
        setNavigationBarAppearance()
        setRootViewController()
        return true
    }
    
    func setNavigationBarAppearance(){
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = .black
        let backImage = UIImage(named: "img_left_arrow")!.withRenderingMode(.alwaysTemplate)
        appearance.backIndicatorImage = backImage
        appearance.backIndicatorTransitionMaskImage = backImage
        //UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset(horizontal: -64, vertical:0), for: .default)
    }
    
    func setRootViewController(){
        if UserData.isLoggedIn{
            let tabBarViewController = TabBarViewController()
            window?.rootViewController = tabBarViewController
        }else{
            let loginView = Storyboard.main.storyboard.instantiateViewController(withIdentifier: StoryboardID.loginViewController)
            window?.rootViewController = loginView
        }
        window?.makeKeyAndVisible()
    }
}

