//
//  WeatherData.swift
//  weather_app
//
//  Created by Max on 16.12.2021.
//

import Foundation
struct WeatherResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [WeatherID]
}

struct WeatherID: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [HourlyWeatherID]
    let pop: Double
}

struct HourlyWeatherID: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct DailyWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moon_phase: Double
    let temp: Temp
    let feels_like: FeelsLikeHourly
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [WeatherHourlyID]
    let clouds: Int
    let pop: Double
    let uvi: Double
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct WeatherHourlyID: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct FeelsLikeHourly: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
