//
//  PlanRadar_TaskTests.swift
//  PlanRadar TaskTests
//
//  Created by Walid Ahmed on 17/04/2025.
//

import Testing
import XCTest
import CoreData
@testable import PlanRadar_Task

class WeatherUseCaseTests: XCTestCase {
    var weatherUseCase: WeatherUseCase!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        let persistentContainer = NSPersistentContainer(name: "Weather")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            XCTAssertNil(error)
        }
        context = persistentContainer.viewContext
        weatherUseCase = WeatherUseCase(context: context)
    }

    override func tearDown() {
        weatherUseCase = nil
        context = nil
        super.tearDown()
    }

    func testSaveWeatherData_NewCity() {
        let weatherData = WeatherData(weather: [Weather(main: "Clear", icon: "01d")], main: Main(temp: 25.0, humidity: 50), wind: Wind(speed: 5.0), sys: Sys(country: "US"), id: 1, name: "Test City")
        weatherUseCase.saveWeatherData(weatherData)
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let cities = try? context.fetch(fetchRequest)
        XCTAssertEqual(cities?.count, 1)
        XCTAssertEqual(cities?.first?.name, "Test City")
    }

    func testSaveWeatherData_ExistingCity() {
        let existingCity = City(context: context)
        existingCity.name = "Existing City"
        existingCity.id = 2
        try? context.save()

        let weatherData = WeatherData(weather: [Weather(main: "Cloudy", icon: "02d")], main: Main(temp: 30.0, humidity: 60), wind: Wind(speed: 3.0), sys: Sys(country: "US"), id: 2, name: "Existing City")

        weatherUseCase.saveWeatherData(weatherData)

        let fetchRequest: NSFetchRequest<WeatherInfo> = WeatherInfo.fetchRequest()
        let weatherInfos = try? context.fetch(fetchRequest)
        XCTAssertEqual(weatherInfos?.count, 1)
        XCTAssertEqual(weatherInfos?.first?.temperature, 30.0)
    }

    func testFetchGroupedWeatherDataByCityId() {
        let city = City(context: context)
        city.name = "Test City"
        city.id = 3
        let weatherInfo = WeatherInfo(context: context)
        weatherInfo.city = city
        weatherInfo.temperature = 20.0
        weatherInfo.date = Date()
        try? context.save()

        let groupedData = weatherUseCase.fetchGroupedWeatherDataByCityId()

        XCTAssertEqual(groupedData.count, 1)
        XCTAssertEqual(groupedData.first?.cityName, "Test City")
        XCTAssertEqual(groupedData.first?.weatherItems.count, 1)
    }
}


