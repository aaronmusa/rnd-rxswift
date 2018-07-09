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

class MapViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let bag = DisposeBag()
    var viewModel: MapViewModel!
    var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        cancelButton.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        
    }
    
    override func loadView() {
        viewModel = MapViewModel(repository: Repository.shared)

        viewModel.mapView.subscribe(onNext: { (mapView) in
            mapView.delegate = self
            self.mapView = mapView
            self.view = mapView
        }).disposed(by: bag)
        
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
