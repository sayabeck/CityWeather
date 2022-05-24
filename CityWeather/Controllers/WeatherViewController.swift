//
//  MainViewController.swift
//  CityWeather
//
//  Created by mac mini on 5/9/22.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    
    private var weather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherImage.isHidden = true
        weatherDescription.isHidden = true
        
        searchTextField.delegate = self
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "there is no such city, or an error occurred on the network",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }

}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type city name..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let city = searchTextField.text else { return }
        WeatherManager.shared.fetchWeather(city) { weatherModel in
            self.weather = weatherModel
            
            DispatchQueue.main.async { [self] in
                weatherImage.image = UIImage(systemName: weather?.conditionName ?? "")
                weatherDescription.text = weather?.description ?? ""
                weatherImage.isHidden = false
                weatherDescription.isHidden = false
                textLabel.isHidden = true
            }
        }

        searchTextField.text = ""
    }
}


