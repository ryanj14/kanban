//
//  TaskController.swift
//  kanbanv2
//
//  Created by Ryan on 2018-10-25.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import CoreData

class TaskController: UIViewController
{
    
    @IBOutlet weak var editButton: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addAction(_ sender: Any) {
        print("add")
    }
    @IBAction func editAction(_ sender: Any) {
        print("edit")
    }
}
