//
//  TaskViewCell.swift
//  kanbanv2
//
//  Created by Ryan Joseph on 2018-11-09.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell
{
    @IBOutlet weak var projectTitle: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
