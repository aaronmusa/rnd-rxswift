//
//  MapViewModel.swift
//  RxDemo
//
//  Created by Aaron Musa on 08/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

class MapViewModel {
    
    var repository: RepositoryProtocol!
    
    let bag = DisposeBag()
    
    var mapView : Observable<GMSMapView> {
        
        let camera = GMSCameraPosition.camera(withLatitude: 14.4488507, longitude: 120.9851635, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        return Observable.just(mapView)
    }
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        
    }
    
    func marker(_ mapView: GMSMapView) {
        // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: 14.4488507, longitude: 120.9851635)
            marker.map =  mapView
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) -> String{
        let geocoder = GMSGeocoder()
        
        var locationString: String?
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            locationString = lines.joined(separator: "\n")
        }
        
        return locationString ?? ""
    }
}




