//
//  Map2ViewController.swift
//  RxDemo
//
//  Created by Aaron Musa on 21/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RxSwift
import RxCocoa

enum Location {
    case startLocation
    case destinationLocation
}

class Map2ViewController: UIViewController {
    
    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let bag = DisposeBag()
    
    var viewModel: Map2ViewModel!
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    var places: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = Map2ViewModel(Repository.shared)
        
        places = GMSPlacesClient.shared()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //Your map initiation code
        places.currentPlace { (places, error) in
            if let err = error {
                print(err)
                return
            }
            
            if let place = places?.likelihoods.first?.place {
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
                
                self.googleMaps.camera = camera
                self.googleMaps.delegate = self
                self.googleMaps?.isMyLocationEnabled = true
                self.googleMaps.settings.myLocationButton = true
                self.googleMaps.settings.compassButton = true
                self.googleMaps.settings.zoomGestures = true
            }
        }
        
        cancelButton.rx.tap.subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
        
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(latitude, longitude)
            marker.title = titleMarker
            marker.icon = iconMarker
            marker.map = googleMaps
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        viewModel.getRoute(origin, destination: destination) { (routes) in
            for route in routes{
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                UIView.animate(withDuration: 5, animations: {
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.googleMaps
                })
            }
        }
    }
    
    // MARK: when start location tap, this will open the search location
    @IBAction func openStartLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .startLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    // MARK: when destination location tap, this will open the search location
    @IBAction func openDestinationLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .destinationLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    // MARK: SHOW DIRECTION WITH BUTTON
    @IBAction func showDirection(_ sender: UIButton) {
        // when button direction tapped, must call drawpath func
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
    }
    
}

// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension Map2ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        
        // set coordinate to text
        if locationSelected == .startLocation {
            startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "marker"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        } else {
            destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "marker"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
        self.googleMaps.camera = camera
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension Map2ViewController: GMSMapViewDelegate {
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

extension Map2ViewController: CLLocationManagerDelegate {
    
}

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
}
