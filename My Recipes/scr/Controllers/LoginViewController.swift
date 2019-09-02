//
//  LoginViewController.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import Moya
import Toaster

class LoginViewController: UIViewController {
    
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblTagLine: UILabel!
    @IBOutlet weak var tfEmail: TextField!
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    var indicator: IndicatorView!
    let userProvider = MoyaProvider<UserServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = IndicatorView(view: view)
    }
    
    @IBAction func loginTapped() {
        let email = tfEmail.text!
        let password = tfPassword.text!
        
        if email.isEmpty || password.isEmpty {
            Toast(text: Messages.emailAndPasswordAreRequired).show()
            return
        }
        
        indicator.startAnimation()
        userProvider.request(.login(email: tfEmail.text!, password: tfPassword.text!)) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    let loginInfo = try JSONDecoder().decode(LoginInfo.self, from: response.data)
                    if let error = loginInfo.error{
                        Toast(text: error).show()
                    }else{
                        print(loginInfo)
                        UserData.doLogin(info: loginInfo)
                    }
                }catch let error{
                    print(error)
                }
                break
            case let .failure(error):
                print("failure",error)
                break
            }
        }
    }
    
    @IBAction func forgotPasswordTapped() {
        
    }
}
