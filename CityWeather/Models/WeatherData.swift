//
//  WeatherData.swift
//  CityWeather
//
//  Created by mac mini on 5/9/22.
//

import Foundation

struct WeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
}
