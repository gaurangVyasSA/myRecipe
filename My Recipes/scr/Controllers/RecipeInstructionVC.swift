//
//  RecipeInstructionVC.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 30/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import Moya
import Toaster

class RecipeInstructionVC: UITableViewController {
    
    static var instance: RecipeInstructionVC{
        return RecipeInstructionVC(style: .grouped)
    }
    
    private var indicator: IndicatorView!
    private var cellId = "cell"
    
    var recipeId: Int?
    private var instructionArray: [Instruction] = []
    
    private let recipeProvider = MoyaProvider<ReceipesServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewControllerTitle.instructions
        if recipeId == nil{
            navigationController?.popViewController(animated: true)
            return
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        navigationItem.rightBarButtonItem = addButton
        indicator = IndicatorView(view: navigationController!.view)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        getInstruction()
    }
    
    // MARK: - Table view data source & Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructionArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = instructionArray[indexPath.row].instruction
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
        if let id = instructionArray[indexPath.row].id{
            instructionArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            removeInstruction(id: id)
        }
    }
    
    //MARK: - Selectors
    
    @objc func addNewItem(){
        presentInputAlertView(title: Messages.enterInstruction) { string in
            self.addInstruction(instruction: string)
        }
    }
    
    //MARK: - Web Services
    
    private func getInstruction(){
        indicator.startAnimation()
        recipeProvider.request(.getinstructions(id: recipeId!)) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    let info = try JSONDecoder().decode([Instruction].self, from: response.data)
                    self.instructionArray = info
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
    
    private func addInstruction(instruction: String){
        indicator.startAnimation()
        let params: [String:Any] = [WSParams.recipeId: recipeId!, WSParams.instruction: instruction]
        recipeProvider.request(.addInstruction(params: params)) { result in
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
                        self.getInstruction()
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
    
    private func removeInstruction(id: Int){
        let params: [String:Any] = [WSParams.recipeId: recipeId!, WSParams.instructionId: id]
        recipeProvider.request(.removeInstruction(params: params)) { result in
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
                        self.getInstruction()
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

