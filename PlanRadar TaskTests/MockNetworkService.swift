//
//  Untitled.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 18/04/2025.
//

import Testing
import XCTest
import Alamofire
@testable import PlanRadar_Task

class MockNetworkService: NetworkService {
    var mockResponse: Result<WeatherData, Error>?

    func request<T: Decodable>(
        method: HTTPMethod,
        url: String,
        headers: [String: String],
        params: Parameters?,
        of type: T.Type
    ) async throws -> T {
        guard let response = mockResponse else {
            throw NSError(domain: "MockError", code: 0, userInfo: nil)
        }
        switch response {
        case .success(let weatherData):
            return weatherData as! T
        case .failure(let error):
            throw error
        }
    }
}

