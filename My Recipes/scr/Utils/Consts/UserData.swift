//
//  UserDefaults.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import Foundation

class UserData: NSObject {
    
    static let kUserId = "ud_userId"
    static let kToken  = "ud_token"
    
    static var userId: Int?{
        return UserDefaults.standard.integer(forKey: kUserId)
    }
    
    static var token: String{
        return UserDefaults.standard.string(forKey: kToken) ?? ""
    }
    
    static var isLoggedIn: Bool{
        return !token.isEmpty
    }
    
    static func doLogin(info:LoginInfo){
        UserDefaults.standard.set(info.id, forKey: kUserId)
        UserDefaults.standard.set(info.token, forKey: kToken)
        AppConsts.appDel.setRootViewController()
    }
    
    static func clear(){
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kToken)
    }
    
    static func logout(){
        clear()
        AppConsts.appDel.setRootViewController()
    }
}
