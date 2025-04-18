//
//  Cities.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

// MARK: - Welcome
struct WeatherData: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?
    var cod: GenericData?
    var message: String?
}

// MARK: - Clouds
struct Clouds: Codable {
    var all: Int?
}
// MARK: - Coord
struct Coord: Codable {
    var lon, lat: Double?
}
// MARK: - Main
struct Main: Codable {
    var temp, feelsLike, tempMin, tempMax: Double?
    var pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}
// MARK: - Sys
struct Sys: Codable {
    var type, id: Int?
    var country: String?
    var sunrise, sunset: Int?
}
// MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main, description, icon: String?
}
// MARK: - Wind
struct Wind: Codable {
    var speed: Double?
    var deg: Int?
}
// MARK: - Grouped Weather Info
struct GroupedWeatherInfo {
    let cityId: Int64
    let cityName: String
    let countryCode: String
    let weatherItems: [WeatherInfo]
}
// MARK: - Weather Detail Item
struct WeatherDetailItem {
    let key: String
    let value: String
}
