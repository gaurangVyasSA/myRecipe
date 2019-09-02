//
//  RecipesServices.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import Foundation

import Moya

enum ReceipesServices {
    case feeds
    case details(id: Int)
    case add(params: [String:Any])
    case addRecipePhoto(recipeId: Int, photo: UIImage)
    case getIngredients(id:Int)
    case addIngredient(params: [String:Any])
    case removeIngredient(params : [String:Any])
    case getinstructions(id:Int)
    case addInstruction(params: [String:Any])
    case removeInstruction(params : [String:Any])
}

extension ReceipesServices: TargetType {
    var task: Task {
        switch self {
        case .feeds, .details, .getIngredients, .getinstructions:
            return .requestPlain
        case .add(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .addRecipePhoto(let recipeId, let photo):
            let imageData = photo.jpegData(compressionQuality: 1)
            let recipeIdData = String(recipeId).data(using: String.Encoding.utf8) ?? Data()
            var formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData!), name:WSParams.photo, fileName: String.randomString(length: 10) + ".jpeg", mimeType: "image/jpeg")]
            formData.append(Moya.MultipartFormData(provider: .data(recipeIdData), name: WSParams.recipeId))
            return .uploadMultipart(formData)
        case .addIngredient(let params):
             return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .removeIngredient(let params):
             return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .addInstruction(let params):
             return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .removeInstruction(let params):
             return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [WSParams.authorization: UserData.token, WSParams.contentType: WSParams.applicationJson]
    }
    
    var baseURL: URL { return URL(string: AppConsts.APIBaseURL + "recipe")! }
    
    var path: String {
        switch self {
        case .feeds:
            return "feeds"
        case .details(let id):
            return "\(id)/details"
        case .add:
            return "add"
        case .addRecipePhoto:
            return "add-update-recipe-photo"
        case .getIngredients(let id):
            return "\(id)/ingredients"
        case .addIngredient:
            return "add-ingredient"
        case .removeIngredient:
            return "rm-ingredient"
        case .getinstructions(let id):
            return "\(id)/instructions"
        case .addInstruction:
            return "add-instruction"
        case .removeInstruction:
            return "rm-instruction"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .feeds, .details, .getinstructions, .getIngredients:
            return .get
        case .add, .addRecipePhoto, .addIngredient, .removeIngredient, .addInstruction, .removeInstruction:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}


