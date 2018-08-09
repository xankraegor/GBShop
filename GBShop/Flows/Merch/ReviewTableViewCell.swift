//
//  ReviewTableViewCell.swift
//  GBShop
//
//  Created by Xan Kraegor on 31.07.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

import UIKit

@IBDesignable class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
}
