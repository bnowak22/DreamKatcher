//
//  DreamTableViewCell.swift
//  DreamKatcher2
//
//  Created by bnowak on 9/29/14.
//  Copyright (c) 2014 bnowak. All rights reserved.
//

import UIKit

class DreamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //set height
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
