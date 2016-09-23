//
//  TrailMapTableViewCell.swift
//  TrailMapper
//
//  Created by Connor Crawford on 9/23/16.
//  Copyright © 2016 Connor Crawford. All rights reserved.
//

import UIKit
import MapKit

class TrailMapTableViewCell: UITableViewCell {

    var trail: Trail? {
        didSet {
            if let trail = trail {
                let location = trail.location
                let span = MKCoordinateSpanMake(1, 1)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                mapView.addAnnotation(trail)
            }
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!

}
