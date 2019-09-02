//
//  RecipeIngredientsVC.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 30/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import Moya
import Toaster

class RecipeIngredientsVC: UITableViewController {
    
    static var instance: RecipeIngredientsVC{
        return RecipeIngredientsVC(style: .grouped)
    }
    
    private var indicator: IndicatorView!
    private var cellId = "cell"
    
    var recipeId: Int?
    private var ingredientArray: [Ingredient] = []
    
    private let recipeProvider = MoyaProvider<ReceipesServices>(plugins: [NetworkLoggerPlugin(verbose: true)])

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewControllerTitle.Ingredients
        if recipeId == nil{
            navigationController?.popViewController(animated: true)
            return
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        navigationItem.rightBarButtonItem = addButton
        indicator = IndicatorView(view: navigationController!.view)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        getIngredients()
    }

    // MARK: - Table view data source & Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = ingredientArray[indexPath.row].ingredient
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let ingredientId = ingredientArray[indexPath.row].id{
            ingredientArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            removeIngredients(ingredientId: ingredientId)
        }
    }
    
    //MARK: - Selectors
    
    @objc func addNewItem(){
        presentInputAlertView(title: Messages.enterIngredient) { string in
            self.addIngredients(ingredient: string)
        }
    }
    
    //MARK: - Web Services
    
    private func getIngredients(){
        indicator.startAnimation()
        recipeProvider.request(.getIngredients(id: recipeId!)) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    let info = try JSONDecoder().decode([Ingredient].self, from: response.data)
                    self.ingredientArray = info
                    self.tableView.reloadData()
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
    
    private func addIngredients(ingredient: String){
        indicator.startAnimation()
        let params: [String:Any] = [WSParams.recipeId: recipeId!, WSParams.ingredient: ingredient]
        recipeProvider.request(.addIngredient(params: params)) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    struct Response: Codable {
                        let msg: String?
                        let id: Int?
                    }
                    let info = try JSONDecoder().decode(Response.self, from: response.data)
                    if let message = info.msg{
                        Toast(text: message).show()
                        self.getIngredients()
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
    
    private func removeIngredients(ingredientId: Int){
        let params: [String:Any] = [WSParams.recipeId: recipeId!, WSParams.ingredientId: ingredientId]
        recipeProvider.request(.removeIngredient(params: params)) { result in
            switch result{
            case let .success(response):
                do{
                    struct Response: Codable {
                        let msg: String?
                    }
                    let info = try JSONDecoder().decode(Response.self, from: response.data)
                    if let message = info.msg{
                        Toast(text: message).show()
                    }else{
                        self.getIngredients()
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


}
