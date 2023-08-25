//
//  ModelPerson.swift
//  testMaps
//
//  Created by Дмитрий Цветков on 22.08.2023.
//

import MapKit
import UIKit

class ModelPerson {
    var persons = [Person]()
    
    init() {
        setup()
    }
    //37.785834, longitude: -122.406417
    func setup() {
        let person1 = Person(coordinate: CLLocationCoordinate2D(latitude: 37.765834, longitude: -122.403417), name: "Иван", date: "22.08.2023", time: "02:35", photo: "car")
        let person2 = Person(coordinate: CLLocationCoordinate2D(latitude: 37.775834, longitude: -122.404417), name: "Илья", date: "23.08.2023", time: "03:35", photo: "car2")
        
        persons.append(person1)
        persons.append(person2)
    }
}
