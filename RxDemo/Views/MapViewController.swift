//
//  MapViewController.swift
//  RxDemo
//
//  Created by Aaron Musa on 08/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let bag = DisposeBag()
    var viewModel: MapViewModel!
    var mapView: GMSMapView!
    
    var placesClient: GMSPlacesClient!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        cancelButton.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        
//        self.getCurrentPlace()
        self.pickPlace()
        
    }
    
    func pickPlace(){
        let center = CLLocationCoordinate2D(latitude: 37.788204, longitude: -122.411937)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
//        placePicker.pickPlace(callback: {(place, error) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            if let place = place {
//                self.nameLabel.text = place.name
//                self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
//                    .joined(separator: "\n")
//            } else {
//                self.nameLabel.text = "No place selected"
//                self.addressLabel.text = ""
//            }
//        })
    }
    
    func getCurrentPlace() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
//            self.nameLabel.text = "No current place"
//            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print(place.name)
                    print(place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n") ?? "")
//                    self.nameLabel.text = place.name
//                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
//                        .joined(separator: "\n")
                }
            }
        })
    }
    override func loadView() {
        viewModel = MapViewModel(repository: Repository.shared)

        viewModel.mapView.subscribe(onNext: { (mapView) in
            mapView.delegate = self
            self.mapView = mapView
            self.view = mapView
            
//            self.getCurrentPlace()
            
//            let cameraPosition = GMSCameraPosition.camera(withLatitude: 14.4488507, longitude: 120.9851635, zoom: 12)
//            self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: cameraPosition)
//            self.mapView.isMyLocationEnabled = true
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: 14.4488507, longitude: 120.9851635)
//            marker.icon = #imageLiteral(resourceName: "marker")
//            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//            marker.map = self.mapView
//            let path = GMSMutablePath()
//            path.add(CLLocationCoordinate2D(latitude: 14.4488507, longitude: 120.9851635))
//            path.add(CLLocationCoordinate2D(latitude: 14.434554300581853, longitude: 121.01142769067383))
//            let rectangle = GMSPolyline(path: path)
//            rectangle.strokeWidth = 2.0
//            rectangle.map = self.mapView
//            self.view = self.mapView
        }).disposed(by: bag)
//
//        let path = GMSMutablePath()
//        path.add(CLLocationCoordinate2D(latitude: 14.4488507, longitude: 120.9851635))
//        path.add(CLLocationCoordinate2D(latitude: 14.434554300581853, longitude: 121.01142769067383))
//        let polyline = GMSPolyline(path: path)
//
//        polyline.map = mapView
//
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let location = viewModel.reverseGeocodeCoordinate(position.target)
        
        let locationObservable = BehaviorRelay<String>(value: "")
        locationObservable.accept(location)
        
        locationObservable.bind { (locationString) in
            print(locationString)
        }.disposed(by: bag)
        
        
    }
}

extension MapViewController: GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print(place.name)
        print( place.formattedAddress?.components(separatedBy: ", ")
            .joined(separator: "\n") ?? "")

    }
    
}
