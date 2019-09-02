//
//  IntructionTableViewCell.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit

class IntructionTableViewCell: UITableViewCell {

    @IBOutlet weak var smallCircleView: UIView!
    @IBOutlet weak var bigCircleView: UIView!
    @IBOutlet weak var lblCircle: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        smallCircleView.clipsToBounds = true
        smallCircleView.layer.cornerRadius = smallCircleView.frame.height / 2
        bigCircleView.clipsToBounds = true
        bigCircleView.layer.cornerRadius = bigCircleView.frame.height / 2
    }

}
