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
    private var coreArray:Array<String> = []
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        tableView.setEditing(true, animated: true)
        tableView.allowsSelectionDuringEditing = true
        
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
    private func deleteData(name:String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Projects")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
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
    
    private func updateData(dataName:String, textName:String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Projects")
        fetchRequest.predicate = NSPredicate(format: "name = %@", dataName)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test[0] as! NSManagedObject
            
           objectUpdate.setValue(textName, forKey: "name")
            
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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    // This will only work for dynamic table view and not static
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : ProjectCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TestingCell", for: indexPath) as! ProjectCellTableViewCell
        let projects = fetchedResultsController.object(at: indexPath)
        cell.deleteButton.tag = indexPath.row
        configureCell(cell, withProjects: projects)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = fetchedResultsController.sections![section]
        let count = sectionInfo.numberOfObjects
        return count
    }
    
    func configureCell(_ cell: ProjectCellTableViewCell, withProjects projects: Projects)
    {
        cell.editCore.isHidden = true
        coreArray.append(projects.name!.description)
        cell.name?.text = projects.name!.description
        cell.deleteButton.passedName = projects.name!.description
        cell.deleteButton.isHidden = true
        cell.editCore.textFieldName = projects.name!.description
        cell.editCore.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.updateButton.isHidden = true
        cell.deleteButton.addTarget(self, action: #selector(helperCreate(_:)), for: UIControl.Event.touchUpInside)
    }
    
    // This is needed to call the createAlert function but selector doesn't allow paramters
    @objc private func helperCreate(_ sender: DeleteButtonSubClass)
    {
        let dataName = sender.passedName
        createAlert(title: "Delete \(dataName)",message: "Are you sure you want to delete \(dataName)?", data: dataName)
    }
    
    @objc func textFieldDidChange(_ textField: ProjectTextField) {
        let originalName:String = textField.textFieldName!
        let changedName:String = textField.text!
        textField.textFieldName = changedName
        updateData(dataName: originalName, textName: changedName)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "ProjectSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectSegue" {
            if let indexPath = sender as? IndexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ProjectCellTableViewCell
                if let nextViewController = segue.destination as? TaskController {
                    nextViewController.titleName = cell.name.text!
                    print(cell.name.text!)
                } else {
                    print("not working")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let movedObject = self.coreArray[sourceIndexPath.row]
        coreArray.remove(at: sourceIndexPath.row)
        coreArray.insert(movedObject, at: destinationIndexPath.row)
        //tableView.reloadData()
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
            self.tableView.reloadData()
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
                    cell.editCore.isHidden = state
                    cell.updateButton.isHidden = state
                    cell.editCore.text = cell.name.text
                    cell.name.isHidden = !state
                }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    // This displays a warning alert about deleting from core data pertaning to the project list
    func createAlert(title:String, message:String, data:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.deleteData(name: data)
            self.toggleDelete(state:false)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.toggleDelete(state:false)
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
