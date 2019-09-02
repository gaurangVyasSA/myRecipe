//
//  FavoritesViewController.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import Moya

class FavoritesViewController: UITableViewController {
    
    var indicator: IndicatorView!
    let feedsProvider = MoyaProvider<ReceipesServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var feedsArray: [RecipeInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewControllerTitle.favorites
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        let addRecipeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))

        navigationItem.rightBarButtonItems = [searchButton, addRecipeButton]
        navigationItem.backBarButtonItem = UIBarButtonItem()
        indicator = IndicatorView(view: navigationController!.view)
        tableView.backgroundColor = .groupTableViewBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecipesList()
    }
    
    @objc func addRecipe(){
        let addRecipeVC = Storyboard.main.storyboard.instantiateViewController(withIdentifier: StoryboardID.addRecipeViewController)
        navigationController?.pushViewController(addRecipeVC, animated: true)
    }
    
    @objc func searchTapped(){
        UserData.logout()
    }
    
    private func reloadData(){
        self.tableView.reloadData()
    }
    
    private func getRecipesList() {
        indicator.startAnimation()
        self.feedsArray.removeAll()
        self.tableView.reloadData()
        feedsProvider.request(.feeds) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    let info = try JSONDecoder().decode([RecipeInfo].self, from: response.data)
                    self.feedsArray = info
                    self.reloadData()
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.favoritesTableViewCell, for: indexPath) as! FavoritesTableViewCell
        let info = feedsArray[indexPath.row]
        cell.prepareUI(recipeInfo: info)
        return cell
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let recipeDetailsVC = Storyboard.main.storyboard.instantiateViewController(withIdentifier: StoryboardID.recipeDetailsViewController) as! RecipeDetailsViewController
        recipeDetailsVC.recipeId = feedsArray[indexPath.row].recipeId
        navigationController?.pushViewController(recipeDetailsVC, animated: true)
    }

}
