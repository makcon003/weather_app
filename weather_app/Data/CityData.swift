//
//  CityData.swift
//  weather_app
//
//  Created by Max on 21.12.2021.
//

import Foundation
struct CityWeatherResponse: Codable {
    let coord: coord
    let weather: [Weather]
    let main: main
    let sys: sys
    let base: String
    let visibility: Int
    let dt: Int
    let timezone: Int
    let name: String
    let cod: Int
}

struct sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct coord: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct wind: Codable {
    let speed: Int
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}
