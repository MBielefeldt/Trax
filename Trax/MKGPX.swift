//
//  MKGPX.swift
//  Trax
//
//  Created by Mads Bielefeldt on 12/07/2015.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import MapKit

extension GPX.Waypoint : MKAnnotation
{
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return info
    }
}
