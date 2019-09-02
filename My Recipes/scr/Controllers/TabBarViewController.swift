//
//  TabBarViewController.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import AZTabBar

class TabBarViewController: UIViewController {
    
    var tabController:AZTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var icons = [UIImage]()
        icons.append(#imageLiteral(resourceName: "img_home"))
        icons.append(#imageLiteral(resourceName: "img_restaurant"))
        icons.append(#imageLiteral(resourceName: "img_favorite"))
        icons.append(#imageLiteral(resourceName: "img_user"))
     
        tabController = AZTabBarController.insert(into: self, withTabIcons: icons)
        tabController.selectedColor = UIColor.primaryColor
        tabController.selectionIndicatorColor = UIColor.primaryColor
        tabController.selectionIndicatorHeight = 3
        
        tabController.setViewController(UIViewController(), atIndex: 0)
        tabController.setViewController(UIViewController(), atIndex: 1)
        
        let favouritesVC = Storyboard.main.storyboard.instantiateViewController(withIdentifier: StoryboardID.favoritesViewController)
        tabController.setViewController(UINavigationController(rootViewController: favouritesVC), atIndex: 2)
        
        tabController.setViewController(UIViewController(), atIndex: 3)
        
        tabController.setIndex(2)
    }
}

