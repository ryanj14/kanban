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
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // instantiate our listener notification
        NotificationCenter.default.addObserver(self, selector: #selector(deleteNotified(n:)), name: NSNotification.Name.init(rawValue: "TestNot"), object: nil)
    }
    
    // The function that will trigger a notification once edit button is pressed
    @objc private func deleteNotified(n:NSNotification)
    {
        print("Triggered")
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestingCell", for: indexPath) as! ProjectCellTableViewCell
        let projects = fetchedResultsController.object(at: indexPath)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.isHidden = true
        // Cannot pass parameters for the selector function
        cell.deleteButton.addTarget(self, action: #selector(helperCreate), for: UIControl.Event.touchUpInside)
        configureCell(cell, withProjects: projects)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withProjects projects: Projects)
    {
        cell.textLabel!.text = projects.name!.description
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "ProjectSegue", sender: self)
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
    
    // This edit button will only display the visible cells
    @IBAction func editProject(_ sender: UIButton)
    {
        var state = false
        editButton.isSelected = !editButton.isSelected
        
        if editButton.isSelected
        {
            editButton.setTitle("Done", for: .normal)
            toggleDelete(state: state)
        }
        else
        {
            state = true
            editButton.setTitle("Edit", for: .normal)
            toggleDelete(state: state)
        }
        //NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "TestNot"), object: nil)
    }
    
    private func toggleDelete(state:Bool)
    {
        tableView?.visibleCells.forEach
            {
                cell in if let cell = cell as? ProjectCellTableViewCell
                {
                    cell.deleteButton.isHidden = state
                }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    // This is needed to call the createAlert function but selector doesn't allow paramters
    @objc private func helperCreate()
    {
        createAlert(title: "Delete Testing",message: "Are you sure you want to delete Testing?")
    }
    
    // This displays a warning alert about deleting from core data pertaning to the project list
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.deleteData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
