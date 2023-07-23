//
//  Currency.swift
//  DT_Quentin_Travel-Application_052023
//
//  Created by Quentin Dubut-Touroul on 15/05/2023.
//

import Foundation

struct CurrencySymbols: Decodable {
    let success: Bool
    let symbols: [String: String]
}

struct CurrencyRate: Decodable {
    let result: Float
}

class CurrencyService {
    private var apiURLBase = "https://api.apilayer.com/fixer/"
    private var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getChangeFor(currency: String, amount: String, callBack: @escaping (Bool, CurrencyRate?) -> Void) {
        // Create a URL object with the API endpoint
        let url = URL(string: apiURLBase + "convert?to=\(currency)&from=USD&amount=\(amount)")!

        // Create a URLRequest object with the URL
        var request = URLRequest(url: url)
        
        // Set the HTTP method
        request.httpMethod = "GET"
        
         let key = Bundle.main.object(forInfoDictionaryKey: "CURRENCY_API_KEY") as! String
        
        // Set the custom header
        request.addValue(key, forHTTPHeaderField: "apikey")
                
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
                            let currencyChangeData = try JSONDecoder().decode(CurrencyRate.self, from: data)
                            callBack(true, currencyChangeData)
                            return

                        } catch {
                            callBack(false, nil)
                            return
                        }
                    }
                } else {
                    // API request failed
                    callBack(false, nil)
                    return
                }
            }
        }
        task.resume()
    }
    

    func getSymbols(callBack: @escaping (Bool, CurrencySymbols?) -> Void) {
        // Create a URL object with the API endpoint
        let url = URL(string: apiURLBase + "symbols")!
        // Create a URLRequest object with the URL
        var request = URLRequest(url: url)
        
        // Set the HTTP method
        request.httpMethod = "GET"
        
        let key = Bundle.main.object(forInfoDictionaryKey: "CURRENCY_API_KEY") as! String
        
        // Set the custom header
        request.addValue(key, forHTTPHeaderField: "apikey")
        
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
                            let currencySymbolsData = try JSONDecoder().decode(CurrencySymbols.self, from: data)
                            callBack(true, currencySymbolsData)
                            return

                        } catch {
                            callBack(false, nil)
                            return
                        }
                    }
                } else {
                    // API request failed
                    callBack(false, nil)
                    return
                }
            }
        }
        task.resume()
    }
}
