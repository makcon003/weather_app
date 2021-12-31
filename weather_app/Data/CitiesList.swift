//
//  CitiesList.swift
//  weather_app
//
//  Created by Max on 25.12.2021.
//

import Foundation
struct Cities: Codable {
    let city: String
    let lat: String
    let lng: String
    let country: String
    let iso2: String
    let admin_name: String
    let capital: String
    let population: String
    let population_proper: String
}
