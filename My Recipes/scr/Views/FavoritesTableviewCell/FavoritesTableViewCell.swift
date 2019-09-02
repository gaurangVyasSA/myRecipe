//
//  FavoritesTableViewCell.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import Kingfisher

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblRecipeType: UILabel!
    @IBOutlet weak var lblRecipeName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComplexity: UILabel!
    @IBOutlet weak var lblServes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 6
    }
    
    func prepareUI(recipeInfo: RecipeInfo){
        selectionStyle = .none
        imgBanner.kf.setImage(with: recipeInfo.photo, placeholder: UIImage(named: "img_placeholder"))
        lblRecipeType.text = "Pasta".uppercased()
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
    }

}
