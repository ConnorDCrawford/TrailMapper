//
//  Trail.swift
//  TrailMapper
//
//  Created by Connor Crawford on 9/23/16.
//  Copyright © 2016 Connor Crawford. All rights reserved.
//

import CoreLocation
import MapKit

class Trail: NSObject {
    
    enum Difficulty: String {
        case easy = "Easy"
        case intermediate = "Intermediate"
        case hard = "Hard"
    }
    
    private(set) var name: String
    private(set) var location: CLLocation
    private(set) var distance: CLLocationDistance
    private(set) var duration: TimeInterval
    private(set) var difficulty: Difficulty
    private(set) var price: Double?
    private(set) var trailDescription: String?
    
    init(name: String, location: CLLocation, distance: CLLocationDistance, duration: TimeInterval, difficulty: Difficulty) {
        self.name = name
        self.location = location
        self.distance = distance
        self.duration = duration
        self.difficulty = difficulty
        super.init()
    }
    
    convenience init(name: String, location: CLLocation, distance: CLLocationDistance, duration: TimeInterval, difficulty: Difficulty, price: Double) {
        self.init(name: name, location: location, distance: distance, duration: duration, difficulty: difficulty)
        self.price = price
    }
    
    convenience init(name: String, location: CLLocation, distance: CLLocationDistance, duration: TimeInterval, difficulty: Difficulty, trailDescription: String) {
        self.init(name: name, location: location, distance: distance, duration: duration, difficulty: difficulty)
        self.trailDescription = trailDescription
    }
    
    convenience init(name: String, location: CLLocation, distance: CLLocationDistance, duration: TimeInterval, difficulty: Difficulty, price: Double, trailDescription: String) {
        self.init(name: name, location: location, distance: distance, duration: duration, difficulty: difficulty)
        self.price = price
        self.trailDescription = trailDescription
    }
    
    static func retrieveTrails(resultsHandler: @escaping (Trail) -> Void) {
        
        // TODO: remove test property
        var trails = [Trail]()
        trails.append(Trail(name: "Pennypack Creek Trail",
                            location: CLLocation.init(latitude: 40.1571262, longitude: -75.0832567),
                            distance: 20921.47,
                            duration: 15120,
                            difficulty: .easy))
        trails.append(Trail(name: "Lehigh Gorge Trail",
                            location: CLLocation.init(latitude: 40.9682116, longitude: -75.7363847),
                            distance: 32186.88,
                            duration: 23220,
                            difficulty: .easy))
        trails.append(Trail(name: "Perkiomen Trail",
                            location: CLLocation.init(latitude: 40.2355132, longitude: -75.454249),
                            distance: 16093.44,
                            duration: 11628,
                            difficulty: .easy))
        trails.append(Trail(name: "The Wissahickon Green Ribbon Trail",
                            location: CLLocation.init(latitude: 40.2034534, longitude: -75.2921741),
                            distance: 4828.03,
                            duration: 3492,
                            difficulty: .easy))
        
        // TODO: Connect to database, remove testing code
        // Just get trails from local data for now, using async after to simulate DB fetch
        for trail in trails {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                resultsHandler(trail)
            }
        }
        
    }
    
}

// MARK: - MKAnnotation

extension Trail: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    
    var title: String? {
        get {
            return name
        }
    }
    
    var subtitle: String? {
        get {
            return "\(String(format: "%.1lf", distance/1000)) km | \(String(format: "%.1lf", duration/3600)) hours | \(difficulty.rawValue)"
        }
    }
    
}
