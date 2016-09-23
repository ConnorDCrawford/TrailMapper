//
//  TrailTableViewController.swift
//  TrailMapper
//
//  Created by Connor Crawford on 9/23/16.
//  Copyright © 2016 Connor Crawford. All rights reserved.
//

import UIKit

class TrailTableViewController: UITableViewController {
    
    var trail: Trail?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        var numberOfRows = 3 // Number of required attributes
        if trail?.price != nil {
            numberOfRows += 1
        }
        if trail?.trailDescription != nil {
            numberOfRows += 1
        }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath)
            if let cell = cell as? TrailMapTableViewCell {
                cell.trail = trail
            }
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Distance"
                cell.detailTextLabel?.text = "\(String(format: "%.1lf", trail!.distance/1000)) km"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Duration"
                cell.detailTextLabel?.text = "\(String(format: "%.1lf", trail!.duration/3600)) hours"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Difficulty"
                cell.detailTextLabel?.text = trail!.difficulty.rawValue
            } else if let price = trail?.price, indexPath.row == 3 {
                cell.textLabel?.text = "Price"
                cell.detailTextLabel?.text = "$\(String(format: "%.2lf", price))"
            } else if let description = trail?.trailDescription, indexPath.row == 3 {
                cell.textLabel?.text = description
            } else if let description = trail?.trailDescription, indexPath.row == 4 {
                cell.textLabel?.text = description
            }
        }
        
        if cell == nil {
            cell = UITableViewCell()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return trail?.name
        }
        return nil
    }

}
