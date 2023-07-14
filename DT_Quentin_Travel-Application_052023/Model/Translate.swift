//
//  Translate.swift
//  DT_Quentin_Travel-Application_052023
//
//  Created by Quentin Dubut-Touroul on 15/05/2023.
//

import Foundation

struct Translation: Codable {
    let translatedText: String
    let detectedSourceLanguage: String
}
struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translations:Codable {
    let data: TranslationData
}

struct Language: Codable {
    let language: String
    let name: String
}

struct LanguageData: Codable {
    let languages: [Language]
}
struct Languages:Codable {
    let data: LanguageData
}


class TranslateService {
    private var apiURLBase = "https://translation.googleapis.com/language/translate/v2"
    private var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    
    
    func getLanguages(callBack: @escaping (Bool, Languages?) -> Void) {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TRANSLATE_API_KEY") as? String, !key.isEmpty else {
            print("API key does not exist")
            return
        }
        
        var urlComponents = URLComponents(string: apiURLBase + "/languages")!
        urlComponents.queryItems = [
            URLQueryItem(name: "model", value: "nmt"),
            URLQueryItem(name: "target", value: "fr"),
            URLQueryItem(name: "key", value: key)
        ]
        
        guard let url = urlComponents.url else {
            callBack(false, nil)
            return
        }

        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for any errors
            if let error = error {
                print("Error: \(error)")
                callBack(false, nil)
                return
            }
            
            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // API request was successful
                        if let data = data {
                            do {
                                let translationData = try JSONDecoder().decode(Languages.self, from: data)
                                callBack(true, translationData)
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
        
    func getTranslationTo(text:String, target: String,callBack: @escaping (Bool, Translations?) -> Void) {
        // Create a URL object with the API endpoint
        var urlComponents = URLComponents(string: apiURLBase)!
        
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TRANSLATE_API_KEY") as? String, !key.isEmpty else {
            print("API key does not exist")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "key", value: key)
        ]
        
        guard let url = urlComponents.url else {
            callBack(false, nil)
            return
        }
        
        // Create a URLRequest object with the URL
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { (data, response, error) in
            
            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // API request was successful
                        if let data = data {
                            do {
                                print(data)
                                let translationData = try JSONDecoder().decode(Translations.self, from: data)
                                callBack(true, translationData)
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
