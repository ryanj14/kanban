//
//  TaskController.swift
//  kanbanv2
//
//  Created by Ryan on 2018-10-25.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import CoreData

class TaskController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createData()
    }

    private func createData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "Projects", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue("Testing", forKey: "name")
        
        do
        {
            try managedContext.save()
        } catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
