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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
