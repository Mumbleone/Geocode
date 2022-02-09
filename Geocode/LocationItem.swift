//
//  LocationItem.swift
//  Geocode
//
//  Created by Adrian Devezin on 6/6/21.
//

import Foundation
import UIKit

class LocationItem: UITableViewCell {
    private var cityView: UILabel!
    private var coordinateView: UILabel!
    static let Identifier = "LocationItemViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        createCityView()
        createCoordinateView()
        
    }
    
    private func createCityView() {
        cityView = UILabel()
        cityView.translatesAutoresizingMaskIntoConstraints = false
        cityView.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        cityView.textColor = UIColor.black
        cityView.numberOfLines = 1
        
        contentView.addSubview(cityView)
        
        cityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        cityView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        cityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    private func createCoordinateView() {
        coordinateView = UILabel()
        coordinateView.translatesAutoresizingMaskIntoConstraints = false
        coordinateView.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        coordinateView.textColor = UIColor.darkGray
        coordinateView.numberOfLines = 1
        
        contentView.addSubview(coordinateView)
        let cityGuide = UILayoutGuide()
        contentView.addLayoutGuide(cityGuide)
        cityGuide.bottomAnchor.constraint(equalTo: cityView.bottomAnchor).isActive = true
        
        coordinateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        coordinateView.topAnchor.constraint(equalTo: cityGuide.bottomAnchor, constant: 4).isActive = true
        coordinateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    func setPresentable(presentable: LocationPresentable) {
        cityView.text = presentable.city
        coordinateView.text = presentable.coordinate
    }
}
