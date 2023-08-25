//
//  ViewController.swift
//  testMaps
//
//  Created by Дмитрий Цветков on 21.08.2023.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager: LocationManager = LocationManager()
    let alertManager: AlertManager = AlertManager()
    let modelPerson = ModelPerson()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.fillMapView(mapView: mapView, modelPerson: modelPerson)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.checkLocationServicesEnable(mapView: mapView, delegate: self) { title, message in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.alertManager.configureAlertController(on: self, title: title, message: message)
            }
        }
    }
    
// MARK: - actions
    @IBAction func plus(_ sender: Any) {
        mapView.camera.centerCoordinateDistance = mapView.camera.centerCoordinateDistance - 5000
    }
    
    @IBAction func minus(_ sender: Any) {
        mapView.camera.centerCoordinateDistance = mapView.camera.centerCoordinateDistance + 5000
    }
    
    @IBAction func goToOurPosition(_ sender: Any) {
        mapView.camera.centerCoordinate = mapView.userLocation.coordinate
    }
}

// MARK: - methods of CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000) // На сколько приближать карту
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.checkAuthorizationStatus(mapView: mapView) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.alertManager.configureAlertController(on: self, title: "You have forbidden", message: "Do you want to turn them on?")
            }
        }
    }
}

// MARK: - methods of MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotaton = annotation as? Person else {
            let viewMarker = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            viewMarker.image = UIImage(named: "myTrack")
            viewMarker.canShowCallout = true
            return viewMarker
        }

        var viewMarker: MKAnnotationView
        let idView = "marker"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) {
            view.annotation = annotaton
            viewMarker = view
        } else {
            viewMarker = MKAnnotationView(annotation: annotaton, reuseIdentifier: idView)
        }
        viewMarker.canShowCallout = true
        
        locationManager.setImageOnAnnotation(annotaton: annotaton, viewMarker: viewMarker)
        
        return viewMarker
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        if let annotation = annotation as? Person {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let bottomVC = storyboard.instantiateViewController(withIdentifier: "SheetVC") as? BottomSheetVC

            if let sheet = bottomVC?.sheetPresentationController {
                sheet.detents = [.custom(identifier: .medium, resolver: { context in
                    0.2 * context.maximumDetentValue
                })]
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            
            bottomVC?.dateLabelText = annotation.date
            bottomVC?.nameLabelText = annotation.name
            bottomVC?.timeLabelText = annotation.time
            bottomVC?.imageText = annotation.photo
            present(bottomVC ?? UIViewController(), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        dismiss(animated: true)
    }
}
