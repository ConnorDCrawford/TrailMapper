//
//  TrailsTableViewController.swift
//  TrailMapper
//
//  Created by Connor Crawford on 9/23/16.
//  Copyright © 2016 Connor Crawford. All rights reserved.
//

import UIKit

class TrailsTableViewController: UITableViewController {

    var trails = [Trail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Trail.retrieveTrails { (trail) in
            self.trails.append(trail)
            self.trails.sort(by: { (t1, t2) -> Bool in
                return t1.name.compare(t2.name) == .orderedAscending
            })
            if let index = self.trails.index(of: trail) {
                self.tableView.insertRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailCell", for: indexPath)
        let trail = trails[indexPath.row]
        cell.textLabel?.text = trail.title
        cell.detailTextLabel?.text = trail.subtitle
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, segue.identifier == "showTrail" {
            if let index = tableView.indexPath(for: cell)?.row {
                let trail = trails[index]
                let trailVC = segue.destination as? TrailTableViewController
                trailVC?.trail = trail
            }
        }
    }

}
