//
//  WeatherViewModel.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import RxSwift
import RxCocoa
import Alamofire
import CoreData
import UIKit

class WeatherViewModel {
    let isLoading = BehaviorRelay<Bool>(value: false)
    var currentWeatherForCity = BehaviorRelay<WeatherData>(value: WeatherData())
    var savedCities = BehaviorRelay<[GroupedWeatherInfo]>(value: [])
    var selectedCityWeatherHistory = BehaviorRelay<GroupedWeatherInfo?>(value: nil)
    var weatherAttributes = BehaviorRelay<[WeatherDetailItem]>(value: [])

    private let weatherService: WeatherProtocol
    private let weatherUseCase: WeatherUseCaseProtocol

    init(weatherService: WeatherProtocol, weatherUseCase: WeatherUseCaseProtocol) {
        self.weatherService = weatherService
        self.weatherUseCase = weatherUseCase
    }

    func getWeatherData(searchText: String) {
        isLoading.accept(true)
        weatherService.getWeatherData(searchText: searchText, completion: { [weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            switch result {
            case .success(let response):
                self.currentWeatherForCity.accept(response)
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        })
    }
    func saveWeatherData(weatherData: WeatherData) {
        weatherUseCase.saveWeatherData(weatherData)
    }
    func fetchSavedWeatherData() {
        let grouped = weatherUseCase.fetchGroupedWeatherDataByCityId()
        savedCities.accept(grouped)
    }
    func fetchWeatherAttributes(){
        weatherAttributes.accept(weatherUseCase.convertWeatherInfoToKeyValueArray(selectedCityWeatherHistory.value?.weatherItems.first ?? WeatherInfo()))
    }
    func selectCityWeatherHistory(index: Int){
        selectedCityWeatherHistory.accept(savedCities.value[index])
    }
}
