//
//  ProjectCellTableViewCell.swift
//  kanbanv2
//
//  Created by Ryan Joseph on 2018-10-28.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation
import UIKit

class ProjectCellTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var name: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteFunction() {
        print("Button pressed")
    }
    
    func toggleDelete(state:Bool)
    {
        print(state)
       // self.deleteButton.isHidden = state
    }
}
