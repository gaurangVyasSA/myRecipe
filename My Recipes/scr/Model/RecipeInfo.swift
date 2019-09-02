//
//  RecipeInfo.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import Foundation

struct RecipeInfo: Codable {
    let recipeId :Int?
    let name :String?
    let photo :URL?
    let preparationTime :String?
    let serves :String?
    let complexity :String?
    let firstName :String?
    let lastName :String?
}
