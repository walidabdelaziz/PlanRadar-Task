//
//  CitiesTVCell.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit

class CitiesTVCell: UITableViewCell {

    var weatherData: WeatherData? {
        didSet {
            guard let weatherData = weatherData else { return }
            titleLbl.text = "\(weatherData.name ?? ""), \(weatherData.sys?.country ?? "")"
        }
    }
    
    var savedWeatherData: GroupedWeatherInfo? {
        didSet {
            guard let savedWeatherData = savedWeatherData else { return }
            titleLbl.text = "\(savedWeatherData.cityName), \(savedWeatherData.countryCode)"
        }
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.textColor = .secondaryColor
        
    }
}
