//
//  APIService.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import Foundation
import Moya

enum UserServices {
    case login(email:String,password:String)
}

extension UserServices: TargetType {
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: [WSParams.email:email, WSParams.password:password], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [WSParams.contentType: WSParams.applicationJson]
    }
    
    var baseURL: URL { return URL(string: AppConsts.APIBaseURL + "user")! }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
}


