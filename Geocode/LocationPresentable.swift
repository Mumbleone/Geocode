//
//  LocationPresentable.swift
//  Geocode
//
//  Created by Student on 6/17/21.
//

import Foundation
struct LocationPresentable {
    let city: String
    let coordinate: String
    
     static func parse(dict: [String:Any]) -> LocationPresentable? {
        guard let longitude = dict["longitude"], let latitude = dict["latitude"], let city = dict["city"] as? String else {
            return nil
        }
        return LocationPresentable(city: city, coordinate: "\(latitude), \(longitude)")
        }
        
        
    }


