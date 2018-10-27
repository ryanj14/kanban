//
//  ProjectsController.swift
//  kanbanv2
//
//  Created by Ryan Joseph on 2018-10-27.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import CoreData

class ProjectsController: UITableViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // This creates an entry to the data core entity projects
        //createData()
        retreieveData()
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
        print("It works")
    }
    
    private func retreieveData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Projects")

        do
        {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]
            {
                print(data.value(forKey: "name") as! String)
            }
        } catch {
            print("Failed")
        }
    }
}
