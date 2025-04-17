//
//  WeatherService.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import Alamofire

protocol WeatherProtocol {
    func getWeatherData(searchText: String,completion: @escaping (Result<WeatherData, Error>) -> Void)
}
class WeatherService: WeatherProtocol {
    private let networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getWeatherData(searchText: String,completion: @escaping (Result<WeatherData, Error>) -> Void) {
        Task {
            do {
                let params: Parameters = ["q": searchText]
                let response = try await networkService.request(method: .get, url: Constants.WEATHER, headers: [:], params: params, of: WeatherData.self)
                await MainActor.run {
                    completion(.success(response))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
}

