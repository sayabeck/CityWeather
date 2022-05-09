//
//  WeatherModel.swift
//  CityWeather
//
//  Created by mac mini on 5/9/22.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let pressure: Int
    let humidity: Int
    
    var description: String {
            """
            city: \(cityName)
            temperature: \(String(format: "%.1f", temperature))°C
            pressure: \(pressure) mBar
            humidity: \(humidity) %
            """
        }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "smoke"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
}
