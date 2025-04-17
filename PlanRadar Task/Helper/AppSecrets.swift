//
//  AppSecrets.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//
import UIKit

enum AppSecrets {
    static var openWeatherApiKey: String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["OPEN_WEATHER_API_KEY"] as? String else {
            fatalError("Missing OpenWeatherMap API key")
        }
        return key
    }
}
