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
    private var coreArray:[String] = ["Created By:", "Date:", "Time:", "Description:", "Taken By:"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.setEditing(true, animated: true)
        tableView.allowsSelectionDuringEditing = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return coreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskViewCell
        cell.projectTitle?.text = coreArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "detailSegue", sender: self)
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
    
    @IBAction func addAction(_ sender: Any)
    {
        print("add")
    }
    
    @IBAction func editAction(_ sender: Any)
    {
        print("edit")
    }
}
