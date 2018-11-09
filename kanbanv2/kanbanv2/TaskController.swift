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
        // Do any additional setup after loading the view, typically from a nib.
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
    
    @IBAction func addAction(_ sender: Any)
    {
        print("add")
    }
    
    @IBAction func editAction(_ sender: Any)
    {
        print("edit")
    }
}
