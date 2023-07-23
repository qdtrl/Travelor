//
//  WeatherViewController.swift
//  DT_Quentin_Travel-Application_052023
//
//  Created by Quentin Dubut-Touroul on 23/05/2023.
//

import UIKit

class WeatherViewController: UIViewController {
    private var weather = WeatherService(session: .shared)
    private var newyork = false
    private let networkManager = NetworkManager.shared


    @IBOutlet weak var descriptionWeather: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var titleWeather: UILabel!
    @IBOutlet weak var windArrow: UIImageView!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func segmentedLocation(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if ("\(selectedIndex)" == "0") {
            newyork = false
        } else {
            newyork = true
        }
        loadingIndicator.startAnimating()
        weather.getWeather(newyork: newyork) { (success, weatherData) in
          guard let weatherData = weatherData, success == true else {
             return
          }
          self.update(weather: weatherData)
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
        
        if networkManager.isReachable  {
            loadingIndicator.startAnimating()
            weather.getWeather(newyork: newyork) { (success, weatherData) in
                guard let weatherData = weatherData, success == true else {
                    return
                }
                self.update(weather: weatherData)
            }
        }  else {
            let alert = UIAlertController(title: "Connection Impossible", message: "Cette application requiert d'être connecter à Internet", preferredStyle: .alert)
              
              // Add an action to the alert (OK button)
              let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                  exit(0)
              }
              
              // Add the action to the alert
              alert.addAction(okAction)
              
              // Present the alert to the user
              present(alert, animated: true, completion: nil)
        }
    }
    
    private func update(weather: WeatherData) {
        let imageUrlString = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
        // Create a URL object from the string
        if let imageUrl = URL(string: imageUrlString) {
            // Use URLSession to download the image data asynchronously
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    // Handle any errors that occur during the download
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    // Update the UI on the main queue
                    DispatchQueue.main.async { [ weak self ] in
                        self?.iconWeather.image = image
                        self?.windSpeed.text = "\(round(weather.wind.speed * 1.94384 * 10) / 10) nds"
                        self?.windArrow.transform = (self?.windArrow.transform.rotated(by: CGFloat(Double(weather.wind.deg) * .pi / 180.0)))!
                        self?.minTemp.text = "\(round(weather.main.temp_min  * 10) / 10)°"
                        self?.maxTemp.text = "\(round(weather.main.temp_max * 10) / 10)°"
                        self?.descriptionWeather.text = weather.weather[0].description
                        self?.titleWeather.text = weather.weather[0].main
                        self?.loadingIndicator.stopAnimating()
                    }
                }
            }.resume() // Start the download task
        }
    }
}
