//
//  CitiesTVCell.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit
import RxSwift
import RxCocoa

protocol HistoryProtocol{
    func didPressHistoryBtn(_ sender: UIButton)
}
class CitiesTVCell: UITableViewCell {

    let disposeBag = DisposeBag()
    var historyDelegate: HistoryProtocol?
    
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
    
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.textColor = .secondaryColor
        bindUI()
    }
    func bindUI(){
        // bind history button
        historyBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.historyDelegate?.didPressHistoryBtn(historyBtn)
            }).disposed(by: disposeBag)

    }
}
