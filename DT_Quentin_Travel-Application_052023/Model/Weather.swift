//
//  Weather.swift
//  DT_Quentin_Travel-Application_052023
//
//  Created by Quentin Dubut-Touroul on 24/05/2023.
//

import Foundation

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainInfo: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct WeatherData: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let main: MainInfo
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

class WeatherService {
    private var apiURLBase = "https://api.openweathermap.org/data/2.5/weather?"
    private var location = LocationManager()
    private var session: URLSession = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
        location.requestLocation()
    }
    
    func getWeather(newyork:Bool ,callBack: @escaping (Bool, WeatherData?) -> Void) {
        // Create a URL object with the API endpoint
        var lat = ""
        var lon = ""
        
        if (newyork) {
            lat = "40.7142700"
            lon = "-74.0059700"
        } else {
            lat = "\(location.latitude)"
            lon = "\(location.longitude)"
        }
        guard let key = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String, !key.isEmpty else {
            print("API key does not exist")
            return
        }
                
        guard let url = URL(string: apiURLBase + "lat=\(lat)&lon=\(lon)&appid=\(key)&units=metric") else {
            return
        }
                        
        // Create a URLRequest object with the URL
        var request = URLRequest(url: url)
        
        // Set the HTTP method
        request.httpMethod = "GET"
        
        // Create a data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for any errors
            if let error = error {
                print(error)
                callBack(false, nil)
                return
            }
            
            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // API request was successful
                    if let data = data {
                        do {
                            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                            callBack(true, weatherData)
                            return

                        } catch {
                            print("Error decoding JSON: \(error)")
                            callBack(false, nil)
                            return
                        }
                    }
                } else {
                    // API request failed
                        print("Error HTTP response status code: \(httpResponse.statusCode)")
                    callBack(false, nil)
                    return
                }
            }
        }
        task.resume()
    }
}

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}

