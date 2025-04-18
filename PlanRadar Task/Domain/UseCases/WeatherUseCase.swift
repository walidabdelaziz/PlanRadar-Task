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
    func fetchGroupedWeatherDataByCityId() -> [GroupedWeatherInfo]
    func convertWeatherInfoToKeyValueArray(_ weatherData: WeatherData) -> [WeatherDetailItem]
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
                city.countryCode = weatherData.sys?.country ?? ""
                city.id = Int64(cityId)
            }

            let weatherInfo = WeatherInfo(context: context)
            weatherInfo.temperature = weatherData.main?.temp ?? 0.0
            weatherInfo.humidity = "\(weatherData.main?.humidity ?? 0)%"
            weatherInfo.desc = weatherData.weather?.first?.main ?? ""
            weatherInfo.icon = weatherData.weather?.first?.icon ?? ""
            weatherInfo.windspeed = "\(weatherData.wind?.speed ?? 0.0) km/h"
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
    func fetchGroupedWeatherDataByCityId() -> [GroupedWeatherInfo] {
        let fetchRequest: NSFetchRequest<WeatherInfo> = WeatherInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let results = try context.fetch(fetchRequest)
            let grouped = Dictionary(grouping: results) { (weatherInfo) -> Int64 in
                return weatherInfo.city?.id ?? -1
            }
            let result = grouped.compactMap { (cityId, weatherInfos) -> GroupedWeatherInfo? in
                guard let city = weatherInfos.first?.city else { return nil }
                return GroupedWeatherInfo(
                    cityId: cityId,
                    cityName: city.name ?? "Unknown",
                    countryCode: city.countryCode ?? "",
                    weatherItems: weatherInfos
                )
            }
            return result
        } catch {
            print("Failed to fetch weather data: \(error)")
            return []
        }
    }
    func convertWeatherInfoToKeyValueArray(_ weatherData: WeatherData) -> [WeatherDetailItem] {
        var items: [WeatherDetailItem] = []
        let properties = [
            "description": weatherData.weather?.first?.main ?? "",
            "temperature": weatherData.main?.temp?.toCelsiusString,
            "humidity": "\(weatherData.main?.humidity ?? 0)%",
            "windspeed": "\(weatherData.wind?.speed ?? 0.0) km/h"
        ]
        let sortedKeys = properties.keys.sorted()
        for key in sortedKeys {
            if let value = properties[key] {
                let valueStr = "\(value ?? "")"
                items.append(WeatherDetailItem(key: key.uppercased(), value: valueStr))
            }
        }
        return items
    }
}
