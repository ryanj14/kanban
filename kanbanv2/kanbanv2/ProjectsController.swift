//
//  ProjectsController.swift
//  kanbanv2
//
//  Created by Ryan Joseph on 2018-10-27.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import CoreData

class ProjectsController: UITableViewController, NSFetchedResultsControllerDelegate
{
    private var managedObjectContext: NSManagedObjectContext? = nil
    
    // for the addProjects function
    private var counter:Int = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // This creates an entry to the data core entity projects
        //createData()
        //retreieveData()
    }
    
    private func createData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "Projects", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue("Testing\(counter)", forKey: "name")
        
        do
        {
            try managedContext.save()
            
        } catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
        print("It works")
        counter += 1
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
        }
        catch
        {
            print("Failed")
        }
    }
    
    // This will delete the data stored on that cell from the core data
    private func deleteData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Projects")
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Testing1")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = fetchedResultsController.sections![section]
        let count = sectionInfo.numberOfObjects
        
        return count
    }
    
    // This will only work for dynamic table view and not static
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestingCell", for: indexPath)
        let projects = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withProjects: projects)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withProjects projects: Projects)
    {
        cell.textLabel!.text = projects.name!.description
    }
    
    // MARK: - Fetched results controller
    var _fetchedResultsController: NSFetchedResultsController<Projects>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Projects>
    {
        if _fetchedResultsController != nil
        {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Projects> = Projects.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
    
        do
        {
            try _fetchedResultsController!.performFetch()
        }
        catch
        {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    // Adds a default cell called "Testing(w/e the int value is)
    @IBAction func addProject(_ sender: Any)
    {
        createData()
        self.tableView.reloadData()
    }
    
    // This will edit the project page but will test delete function first
    @IBAction func editProject(_ sender: Any)
    {
        deleteData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
}

struct Project : Codable
{
    let name: String?
    
    private enum CodingKeys: String, CodingKey
    {
        case name
    }
}
