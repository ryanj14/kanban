//
//  DetailsController.swift
//  kanbanv2
//
//  Created by Ryan on 2018-10-26.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class DetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var coreArray:[String] = ["Created By:", "Date:", "Time:", "Description:", "Taken By:"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return coreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailsViewCell
        cell.DetailName?.text = coreArray[indexPath.row]
        cell.userText.isHidden = true
        return cell
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
                cell in if let cell = cell as? DetailsViewCell
                {
                    cell.UserDetail.isHidden = !state
                    cell.userText.text = cell.UserDetail.text
                    cell.userText.isHidden = state
                }
        }
    }
}
