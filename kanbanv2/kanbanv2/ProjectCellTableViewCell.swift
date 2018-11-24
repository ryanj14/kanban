//
//  ProjectCellTableViewCell.swift
//  kanbanv2
//
//  Created by Ryan Joseph on 2018-10-28.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation
import UIKit

class ProjectCellTableViewCell: UITableViewCell
{
    var passNamed:String?
    @IBOutlet weak var deleteButton: DeleteButtonSubClass!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var editCore: ProjectTextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
