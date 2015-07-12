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
    
    private func getImageURLForType(type: String) -> NSURL?
    {
        for link in links {
            if link.type == type {
                return link.url
            }
        }
        
        return nil
    }
    
    var thumbnailURL: NSURL? {
        return self.getImageURLForType("thumbnail")
    }
    
    var imageURL: NSURL? {
        return self.getImageURLForType("large")
    }
}
