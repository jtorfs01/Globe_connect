//
//  Activity.swift
//  globe_connect
//
//  Created by Jonas Torfs on 20/10/15.
//  Copyright © 2015 Jonas Torfs. All rights reserved.
//

import UIKit
import MapKit

class Activity: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
       var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
          }
}


