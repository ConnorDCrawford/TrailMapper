//
//  ExploreTrailsViewController.swift
//  TrailMapper
//
//  Created by Connor Crawford on 9/23/16.
//  Copyright © 2016 Connor Crawford. All rights reserved.
//

import UIKit
import MapKit

class ExploreTrailsViewController: UIViewController {
    
    fileprivate var searchResultsController: UITableViewController!
    fileprivate var searchController: UISearchController!
    fileprivate let locationManager = CLLocationManager()
    fileprivate var location: CLLocation?
    fileprivate var trails = [Trail]()
    fileprivate var searchResults = [Trail]()
    fileprivate var showingOptions = true
    fileprivate var selectedTrail: Trail?
    
    @IBOutlet weak var trailsMapView: MKMapView!
    @IBOutlet var optionsBlurryBackground: UIVisualEffectView!
    @IBOutlet var optionsBottomLayoutConstant: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up searchResultsController
        let resultsTableView = UITableView()
        searchResultsController = UITableViewController()
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell") // Register cell
        searchResultsController.tableView = resultsTableView
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.delegate = self
        definesPresentationContext = true // Needed or searchResultsController will cover entire view
        
        // Set up searchController
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for trails"
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        navigationItem.titleView = searchController.searchBar
        
        // Set up locationManager
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
        locationManager(locationManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
        
        // Set up trailsMapView
        if let location = locationManager.location {
            self.location = location
            let span = MKCoordinateSpanMake(2, 2)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            trailsMapView.setRegion(region, animated: true)
        } else {
            // Center map on Philadelphia's City Hall
            let location = CLLocation(latitude: 39.9527572, longitude: -75.1660151)
            let span = MKCoordinateSpanMake(2, 2)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            trailsMapView.setRegion(region, animated: true)
        }
        trailsMapView.delegate = self
        
        self.view.layoutIfNeeded() // Need this or else subviews will not be in place when view first appears.
        
        // Handle Trail add
        Trail.retrieveTrails { (trail) in
            self.trails.append(trail)
            self.trailsMapView.addAnnotation(trail)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Show the navigationController's toolbar before view appears
        self.navigationController?.isToolbarHidden = false
        
        if showingOptions {
            setMenu(hidden: true, animated: false)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide the navigationController's toolbar as view disappears
        self.navigationController?.isToolbarHidden = true
        
    }
    
    func performSearch(_ searchText: String) {
        searchResults.removeAll()
        for trail in trails {
            if trail.name.lowercased().contains(searchText.lowercased()) {
                searchResults.append(trail)
            }
        }
    }
    
    // animates showing/hiding of the map options menu
    func setMenu(hidden: Bool, animated: Bool){
        showingOptions = !hidden
        var constant:CGFloat = optionsBottomLayoutConstant.constant
        let height = optionsBlurryBackground.frame.height + (self.tabBarController?.tabBar.frame.height ?? 0) // The menu must go over/under the UITabBar
        constant = hidden ? (constant - height) : (constant + height)
        if animated {
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           usingSpringWithDamping: 0.65,
                           initialSpringVelocity: 1,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: {
                            self.optionsBottomLayoutConstant.constant = constant
                            self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            self.optionsBottomLayoutConstant.constant = constant
            self.view.layoutIfNeeded()
        }
    }

    // shows/hides the map options menu when pressed
    @IBAction func infoButtonPressed(_ sender: UIBarButtonItem) {
        setMenu(hidden: showingOptions, animated: true)
    }
    
    @IBAction func mapTypeButtonPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            trailsMapView.mapType = .standard
        } else {
            trailsMapView.mapType = .hybrid
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTrail" {
            let trailVC = segue.destination as? TrailTableViewController
            trailVC?.trail = selectedTrail
        }
    }

}

// MARK: - MKMapViewDelegate

extension ExploreTrailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
        if mode == MKUserTrackingMode.follow || mode == MKUserTrackingMode.followWithHeading {
            
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {
                mapView.userTrackingMode = .none
                let locationDisabledAlertController = UIAlertController(title: "Location Services Disabled",
                                                                        message: "It seems that you have Location Services disabled. Please go to Settings > TUrnt and allow location access.",
                                                                        preferredStyle: .alert)
                locationDisabledAlertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                locationDisabledAlertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (open: UIAlertAction!) -> Void in
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(appSettings)
                    }
                }))
                present(locationDisabledAlertController, animated: true, completion: nil)
            } else {
                locationManager.requestLocation()
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if annotation is MKUserLocation {
            //return nil so map view draws dot for standard user location instead of pin
            return nil
        }
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.isDraggable = false
            pinView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let trail = view.annotation as? Trail {
            selectedTrail = trail
            performSegue(withIdentifier: "showTrail", sender: self)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension ExploreTrailsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // User has allowed Location Services. Get their location.
            manager.requestLocation()
            
            if !(toolbarItems?.first is MKUserTrackingBarButtonItem) {
                // Setting up MKUserTrackingBarButtonItem. This is the same kind of button used in Apple Maps.
                let trackingButton = MKUserTrackingBarButtonItem(mapView: trailsMapView)
                toolbarItems?.insert(trackingButton, at: 0)
            }
            
        } else if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            trailsMapView.userTrackingMode = .none
            if let index = toolbarItems?.index(where: { (item) -> Bool in
                if item is MKUserTrackingBarButtonItem {
                    return true
                }
                return false
            }) {
                self.toolbarItems?.remove(at: index)
            }
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first, self.location == nil {
            self.location = location
            trailsMapView.setCenter(location.coordinate, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if trailsMapView.userTrackingMode != .none {
            // Change user tracking mode to none. This will change the MKUserTrackingBarButtonItem image.
            trailsMapView.userTrackingMode = .none
            
            // Show alert
            let locationUnavailableAlert = UIAlertController(title: "Unable to Get Location",
                                                             message: "Your location is unavailable. Please make sure that you are connected to the Internet.",
                                                             preferredStyle: .alert)
            let dismissLocationAlert = UIAlertAction(title: "Dismiss",
                                                     style: UIAlertActionStyle.cancel) { (dismiss: UIAlertAction!) -> Void in
                                                        print("Error while updating location. " + error.localizedDescription)
            }
            locationUnavailableAlert.addAction(dismissLocationAlert)
            self.present(locationUnavailableAlert, animated: true, completion: nil)
        }
        
    }
    
}

// MARK: - UITableViewDelegate

extension ExploreTrailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTrail = searchResults[indexPath.row]
        performSegue(withIdentifier: "showTrail", sender: self)
    }
    
}

// MARK: - UITableViewDataSource

extension ExploreTrailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") {
            cell.textLabel?.text = searchResults[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UISearchResultsUpdating

extension ExploreTrailsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText != "" {
            performSearch(searchText)
        }
        searchResultsController.tableView.reloadData()
    }
    
}
