//
//  WeatherUseCase.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//
import UIKit
import CoreData

import CoreData

protocol WeatherUseCaseProtocol {
    func saveWeatherData(_ weatherData: WeatherData)
    func fetchSavedWeatherData() -> [WeatherInfo]
}
final class WeatherUseCase: WeatherUseCaseProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func saveWeatherData(_ weatherData: WeatherData) {
        guard let cityName = weatherData.name,
              let cityId = weatherData.id else {
            return
        }
        let cityFetch: NSFetchRequest<City> = City.fetchRequest()
        cityFetch.predicate = NSPredicate(format: "id == %d", cityId)
        do {
            let results = try context.fetch(cityFetch)
            let city: City

            if let existingCity = results.first {
                city = existingCity
            } else {
                city = City(context: context)
                city.name = cityName
                city.id = Int64(cityId)
            }

            let weatherInfo = WeatherInfo(context: context)
            weatherInfo.temperature = weatherData.main?.temp ?? 0.0
            weatherInfo.humidity = Int64(weatherData.main?.humidity ?? 0)
            weatherInfo.desc = weatherData.weather?.first?.description ?? ""
            weatherInfo.date = Date()
            weatherInfo.city = city

            if let weatherInfos = city.weatherInfo?.mutableCopy() as? NSMutableSet {
                weatherInfos.add(weatherInfo)
                city.weatherInfo = weatherInfos
            } else {
                city.weatherInfo = NSMutableSet(object: weatherInfo)
            }
            try context.save()
        } catch {
            let nserror = error as NSError
            print("Failed saving: \(nserror), \(nserror.userInfo)")
        }
    }
    func fetchSavedWeatherData() -> [WeatherInfo] {
        let fetchRequest: NSFetchRequest<WeatherInfo> = WeatherInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch weather data: \(error)")
            return []
        }
    }
}
