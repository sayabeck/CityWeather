//
//  WeatherManager.swift
//  CityWeather
//
//  Created by mac mini on 5/9/22.
//

import UIKit

class WeatherManager {
    private let weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?appid=ccf412399cbc65bba358c2b876b7054c&units=metric&q="
    
    static let shared = WeatherManager()
    
    private init() {}
    
    func fetchWeather (_ cityName: String, with completion: @escaping(WeatherModel) -> Void) {
        let urlWithCity = "\(weatherUrl)\(cityName)"

        guard let url = URL(string: urlWithCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(WeatherData.self, from: data)
                
                let id = jsonData.weather[0].id
                let name = jsonData.name
                let temperature = jsonData.main.temp
                let pressure = jsonData.main.pressure
                let humidity = jsonData.main.humidity
                
                let weather = WeatherModel(
                    conditionId: id,
                    cityName: name,
                    temperature: temperature,
                    pressure: pressure,
                    humidity: humidity)
                
                DispatchQueue.main.async {
                    completion(weather)
                }
            } catch let error {
                print(error.localizedDescription)
                return
            }
            
        }.resume()
    }
}
