//
//  DetailsViewCell.swift
//  kanbanv2
//
//  Created by Ryan on 2018-11-08.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class DetailsViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var DetailName: UILabel!
    @IBOutlet weak var UserDetail: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
