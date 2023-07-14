//
//  WeatherTest.swift
//  DT_Quentin_Travel-Application_052023Tests
//
//  Created by Quentin Dubut-Touroul on 24/06/2023.
//

import XCTest
@testable import DT_Quentin_Travel_Application_052023

class WeatherTest: XCTestCase {
    

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(newyork: false) { (success, weather) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallBackIfNoData() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(newyork: false) { (success, weather) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
    }
    
    func testGetWeatherShouldPostFailedCallBackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(newyork: false) { (success, weather) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallBackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(newyork: false) { (success, weather) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Tests getWeather - When all Ok
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(newyork: true) { (success, weather) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            XCTAssertEqual("New York", weather?.name)
            XCTAssertEqual(25.7, weather?.main.temp)
            XCTAssertEqual("Clouds", weather?.weather[0].main)
            XCTAssertEqual("scattered clouds", weather?.weather[0].description)
            XCTAssertEqual(4.63, weather?.wind.speed)
            XCTAssertEqual(170, weather?.wind.deg)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
