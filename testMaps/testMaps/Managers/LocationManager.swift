//
//  LocationManager.swift
//  testMaps
//
//  Created by Дмитрий Цветков on 25.08.2023.
//

import UIKit
import CoreLocation
import MapKit

protocol LocationManagerCheckProtocol {
    func checkAuthorizationStatus(mapView: MKMapView, completion: () -> Void)
    func checkLocationServicesEnable(mapView: MKMapView, delegate: CLLocationManagerDelegate, completion: @escaping (String, String) -> Void)
}

protocol LocationManagerConfigProtocol {
    func configureLocationManager(delegate: CLLocationManagerDelegate)
    func setImageOnAnnotation(annotaton: Person, viewMarker: MKAnnotationView)
    func fillMapView(mapView: MKMapView, modelPerson: ModelPerson)
}

class LocationManager {
    let locationManager: CLLocationManager = CLLocationManager()
}

extension LocationManager: LocationManagerConfigProtocol {
    func configureLocationManager(delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = .greatestFiniteMagnitude // Точность работы GPS
    }
    
    func setImageOnAnnotation(annotaton: Person, viewMarker: MKAnnotationView) {
        switch annotaton.title! {
        case "Илья":
            viewMarker.image = UIImage(named: "car2")?.resized(to: CGSize(width: 34, height: 34))
        case "Иван":
            viewMarker.image = UIImage(named: "car")?.resized(to: CGSize(width: 34, height: 34))
        default:
            break
        }
    }
    
    func fillMapView(mapView: MKMapView, modelPerson: ModelPerson) {
        for person in modelPerson.persons {
            mapView.addAnnotation(person)
        }
    }
}

extension LocationManager: LocationManagerCheckProtocol {
    func checkAuthorizationStatus(mapView: MKMapView, completion: () -> Void) {
        switch locationManager.authorizationStatus {
        case .authorized:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            completion()
        case .restricted:
            break
        @unknown default:
            print("unknown authorizationStatus")
        }
    }
    
    func checkLocationServicesEnable(mapView: MKMapView, delegate: CLLocationManagerDelegate, completion: @escaping (String, String) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() { // Если служба включена
                self?.configureLocationManager(delegate: delegate)
                self?.checkAuthorizationStatus(mapView: mapView) {
                    completion("You have forbidden", "Do you want to turn them on?")
                }
            } else { // Если служба выключена
                completion("Location services are turned off", "Do you want to turn them on?")
            }
        }
    }
}
