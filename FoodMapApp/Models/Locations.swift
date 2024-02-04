//
//  Locations.swift
//  FoodMapApp
//
//  Created by Marcus Ong on 23/6/22.
//

import Foundation
import MapKit
import CoreLocation

struct Location: Identifiable, Equatable {
    
    
    let name: String
    let subName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    
    var id: String {
        name + subName
    }
    
    //Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
}
