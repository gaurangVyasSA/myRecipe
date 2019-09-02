//
//  AppConsts.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 28/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit

enum AppConsts {
    static let APIBaseURL = "http://35.160.197.175:3006/api/v1/"
    static let appDel     =  UIApplication.shared.delegate as! AppDelegate
}

enum CellID {
    static let favoritesTableViewCell   = "favoritesTableViewCell"
    static let instructionTableViewCell = "instructionTableViewCell"
}

enum Strings {
    static let recipeName   = "Recipe Name"
    static let recipePhoto  = "Recipe Photo"
    static let duration     = "Duration"
    static let complexity   = "Complexity"
    static let serves       = "Serves"
    static let ingredints   = "Ingredients"
    static let instruction  = "Instruction"
    static let cancel       = "Cancel"
    static let ok           = "OK"
    static let easy         = "Easy"
    static let medium       = "Medium"
    static let complex      = "Complex"
    static let save         = "Save"
    static let selected     = "Selected"
    static let camera       = "Camera"
    static let gallery      = "Gallery"
}

enum LabelTitles {
    static let ingredients  = "ingredients"
    static let instructions = "instructions"
}

enum ViewControllerTitle {
    static let favorites    = "Favorites"
    static let addRecipe    = "Add Recipe"
    static let Ingredients  = "Ingredients"
    static let instructions = "Instructions"
}

enum StoryboardID {
    static let loginViewController         = "loginViewController"
    static let favoritesViewController     = "favoritesViewController"
    static let recipeDetailsViewController = "recipeDetailsViewController"
    static let addRecipeViewController     = "addRecipeViewController"
}

enum Storyboard: String {
    case main = "Main"
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
