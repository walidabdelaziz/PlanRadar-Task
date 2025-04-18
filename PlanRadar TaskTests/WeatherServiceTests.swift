//
//  Untitled.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 18/04/2025.
//

import XCTest
import Alamofire
@testable import PlanRadar_Task

class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        weatherService = WeatherService(networkService: mockNetworkService)
    }

    override func tearDown() {
        weatherService = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testGetWeatherData_Success() {
        let expectedWeatherData = WeatherData(
            weather: [Weather(main: "Clear", icon: "01d")], main: Main(temp: 25.0, humidity: 50), wind: Wind(speed: 5.0), sys: Sys(country: "US"), id: 1, name: "Test City"
        )
        mockNetworkService.mockResponse = .success(expectedWeatherData)
        let expectation = self.expectation(description: "Weather data fetched successfully")
        weatherService.getWeatherData(searchText: "Test City") { result in
            switch result {
            case .success(let weatherData):
                XCTAssertEqual(weatherData.name, expectedWeatherData.name)
                XCTAssertEqual(weatherData.main?.temp, expectedWeatherData.main?.temp)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetWeatherData_Failure() {
        mockNetworkService.mockResponse = .failure(NSError(domain: "NetworkError", code: 1, userInfo: nil))
        let expectation = self.expectation(description: "Weather data fetch failed")
        weatherService.getWeatherData(searchText: "Invalid City") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                if let nsError = error as NSError? {
                    XCTAssertEqual(nsError.domain, "NetworkError")
                } else {
                    XCTFail("Error is not of type NSError")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
