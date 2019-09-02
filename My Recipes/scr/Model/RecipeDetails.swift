//
//  RecipeDetails.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import Foundation

// MARK: - RecipeDetails
struct RecipeDetails: Codable {
    let name: String?
    let photo: URL?
    let preparationTime, serves, complexity, firstName: String?
    let lastName: String?
    let ingredients: [Ingredient]?
    let instructions: [Instruction]?
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let id: Int?
    let ingredient: String?
}

// MARK: - Instruction
struct Instruction: Codable {
    let id: Int?
    let instruction: String?
}
