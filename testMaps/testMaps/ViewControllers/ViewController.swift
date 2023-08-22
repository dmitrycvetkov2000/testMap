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
    let locationManager: CLLocationManager = CLLocationManager()
    var alert: UIAlertController = UIAlertController()
    let modelPerson = ModelPerson()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for person in modelPerson.persons {
            mapView.addAnnotation(person)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServicesEnable()
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

// MARK: - methods
extension ViewController {
    func configureAlertController(title: String, message: String?) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {_ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
    }
    
    func checkLocationServicesEnable() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() { // Если служба включена
                self.configureLocationManager()
                self.checkAuthorizationStatus()
            } else { // Если служба выключена
                self.configureAlertController(title: "Location services are turned off", message: "Do you want to turn them on?")
                self.present(self.alert, animated: true)
            }
        }
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = .greatestFiniteMagnitude // Точность работы GPS
    }
    
    func checkAuthorizationStatus() {
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
            configureAlertController(title: "You have forbidden", message: "Do you want to turn them on?")
            DispatchQueue.main.async {
                self.present(self.alert, animated: true)
            }
        case .restricted:
            break
        @unknown default:
            print("unknown authorizationStatus")
        }
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
        checkAuthorizationStatus()
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
        
        setImageOnAnnotation(annotaton: annotaton, viewMarker: viewMarker)
        
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
}
