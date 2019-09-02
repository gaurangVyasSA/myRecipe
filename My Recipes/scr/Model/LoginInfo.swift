//
//  LoginInfo.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import Foundation

struct LoginInfo: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    let token: String?
    let error: String?
}
