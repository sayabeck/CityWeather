//
//  WeatherManager.swift
//  CityWeather
//
//  Created by mac mini on 5/9/22.
//

import UIKit

protocol WeatherManagerDelegate {
    func didSendWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    private let weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?appid=ccf412399cbc65bba358c2b876b7054c&units=metric&q="
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (_ cityName: String) {
        let urlWithCity = "\(weatherUrl)\(cityName)"

        guard let url = URL(string: urlWithCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            guard let weather = parseJson(with: data) else { return }
            self.delegate?.didSendWeather(self, weather: weather)
            
        }.resume()
    }
    
    private func parseJson(with data: Data) -> WeatherModel? {
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
            
            return weather
            
        } catch let error {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
