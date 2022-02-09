//
//  ViewModel.swift
//  Geocode
//
//  Created by Student on 6/17/21.
//

import Foundation
import Combine
import CoreLocation

class ViewModel: ObservableObject {
    
    @Published
    var viewState: ViewState = .initial
    @Published
    var events: Events? = nil
    
    var locations: [[String:Any]] = []
    
    enum ViewState {
        case initial
        case geocodes([[String:Any]])
    }
    
    enum Events {
        case error(String)
    }
    
    func onAddLocationClick(cityParam: String?) {
        if let unwrappedCity = cityParam {
            getGpsCoordinates(city: unwrappedCity)
        }
    }
    
    private func getGpsCoordinates(city: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.isEmpty {
                    self.showError(error: "No Coordinates Found")
                } else {
                    let placemark = placemarks.first?.location?.coordinate
                    if let placemark = placemark {
                        self.addLocation(city: city, location: placemark)
                    }
                }
            } else if let error = error {
                self.showError(error: error.localizedDescription)
            } else {
                self.showError(error: "Have no idea what went wrong")
            }
        }
    }
    
    
    func showError(error: String) {
        events = .error(error)
    }
    
    func addLocation(city: String, location: CLLocationCoordinate2D) {
        var locationDictionary: [String:Any] = [:]
        locationDictionary["city"] = city
        locationDictionary["latitude"] = location.latitude
        locationDictionary["longitude"] = location.longitude
        locations.append(locationDictionary)
        viewState = .geocodes(locations)
    }
    
}
