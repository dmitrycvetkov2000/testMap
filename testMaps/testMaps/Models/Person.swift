//
//  Person.swift
//  testMaps
//
//  Created by Дмитрий Цветков on 22.08.2023.
//

import UIKit
import MapKit

class Person: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String
    var date: String
    var time: String
    var photo: String
    var title: String? {
        return name
    }
    var subtitle: String? {
        return "GPS, \(time)"
    }
    
    init(coordinate: CLLocationCoordinate2D, name: String, date: String, time: String, photo: String) {
        self.coordinate = coordinate
        self.name = name
        self.date = date
        self.time = time
        self.photo = photo
    }
}
