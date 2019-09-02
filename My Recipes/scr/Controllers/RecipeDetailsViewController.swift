//
//  ReciepeDetailsViewController.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import Moya
import Kingfisher

class RecipeDetailsViewController: UIViewController {
    
    private struct TableSection{
        let title: String
        let isIngredients: Bool
        let textArray: [String]
    }
    
    let imageView = UIImageView()
    @IBOutlet weak var lblRecipeType: UILabel!
    @IBOutlet weak var lblRecipeName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComplexity: UILabel!
    @IBOutlet weak var lblServes: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var indicator: IndicatorView!
    var recipeId: Int?
    private var recipeDetails: RecipeDetails?
    private var sectionArray: [TableSection] = []
    
    let recipeProvider = MoyaProvider<ReceipesServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_empty_heart"), style: .plain, target: nil, action: nil)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        indicator = IndicatorView(view: navigationController!.view)
        indicator.backgroundColor = .white
        setupHeaderImage()
        getRecipeDetails()
    }
    
    private func setupHeaderImage(){
    
        tableView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 160)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
    private func prepareUI(){
        guard let recipeInfo = recipeDetails else{
            return
        }
        
        imageView.kf.setImage(with: recipeInfo.photo, placeholder: #imageLiteral(resourceName: "img_placeholder"))
        lblRecipeType.text = "SALAD"
        lblRecipeName.text = recipeInfo.name
        
        if let time = recipeInfo.preparationTime, !time.isEmpty{
            lblTime.setSmallGrayStyle()
            lblTime.isHidden = false
            lblTime.setAttributedText(icon: #imageLiteral(resourceName: "img_clock"), text: time)
        }else{
            lblTime.isHidden = true
        }
        if let complexity = recipeInfo.complexity, !complexity.isEmpty{
            lblComplexity.setSmallGrayStyle()
            lblComplexity.isHidden = false
            lblComplexity.setAttributedText(icon: #imageLiteral(resourceName: "img_bars"), text: complexity)
        }else{
            lblComplexity.isHidden = true
        }
        if let serves = recipeInfo.serves, !serves.isEmpty{
            lblServes.setSmallGrayStyle()
            lblServes.isHidden = false
            lblServes.setAttributedText(icon: #imageLiteral(resourceName: "img_serve"), text: serves)
        }else{
            lblServes.isHidden = true
        }
        
        if let ingredients = recipeInfo.ingredients, !ingredients.isEmpty{
            var textArray: [String?] = []
            for row in ingredients{
                textArray.append(row.ingredient)
            }
            self.sectionArray.append(TableSection(title: LabelTitles.ingredients, isIngredients: true, textArray: textArray.compactMap({$0})))
        }
        
        if let instrictions = recipeInfo.instructions, !instrictions.isEmpty{
            var textArray: [String?] = []
            for row in instrictions{
                textArray.append(row.instruction)
            }
            self.sectionArray.append(TableSection(title: LabelTitles.instructions, isIngredients: false, textArray: textArray.compactMap({$0})))
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        super.viewWillDisappear(animated)
    }
    
    private func getRecipeDetails(){
        guard let recipeId = recipeId else {
            navigationController?.popViewController(animated: true)
            return
        }
        indicator.startAnimation()
        recipeProvider.request(.details(id: recipeId)) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    let info = try JSONDecoder().decode(RecipeDetails.self, from: response.data)
                    self.recipeDetails = info
                    self.prepareUI()
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

//Mark: - TableView DataSource Methods

extension RecipeDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.setSectionHeaderStyle()
        label.text = sectionArray[section].title.uppercased()
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section].textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.instructionTableViewCell, for: indexPath) as! IntructionTableViewCell
        let section = sectionArray[indexPath.section]
        cell.smallCircleView.isHidden = !section.isIngredients
        cell.bigCircleView.isHidden = section.isIngredients
        cell.lblCircle.text = String(indexPath.row + 1)
        cell.lblText.text = section.textArray[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 160 - (scrollView.contentOffset.y + 160)
        let height = min(max(y, 60), 250)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        
    }
    
}
