//
//  TaskController.swift
//  kanbanv2
//
//  Created by Ryan on 2018-10-25.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class TaskController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    var titleName:String = ""
    private var coreArray = [["Created By:", "Date:"], ["Time:", "Description:", "Taken By:"], ["testing"]]
    let headerTitles = ["To Do", "In Progress", "Finished"]
    @IBOutlet weak var projectTitle: UINavigationItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.setEditing(true, animated: true)
        tableView.allowsSelectionDuringEditing = true
        projectTitle.title = titleName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return coreArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return coreArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskViewCell
        cell.projectTitle?.text = coreArray[indexPath.section][indexPath.row]
        cell.deleteButton.isHidden = true
        cell.taskLabel.isHidden = true
        cell.taskLabel.text = coreArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let cell = tableView.cellForRow(at: indexPath) as! TaskViewCell
        //DispatchQueue.main.async { self.performSegue(withIdentifier: "detailSegue", sender: self) }
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let movedObject = self.coreArray[sourceIndexPath.row]
        coreArray.remove(at: sourceIndexPath.row)
        coreArray.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        } else {
            return nil
        }
    }
    
    @IBAction func addAction(_ sender: Any)
    {
        print("add")
    }
    
    @IBAction func editAction(_ sender: Any)
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
    }
    
    private func toggleDelete(state:Bool)
    {
        tableView?.visibleCells.forEach
            {
                cell in if let cell = cell as? TaskViewCell
                {
                    cell.deleteButton.isHidden = state
                    cell.taskLabel.isHidden = state
                }
        }
    }
}
