//
//  CitiesVC.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit
import RxSwift
import RxCocoa

class CitiesVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let weatherViewModel = WeatherViewModel(weatherService: WeatherService(networkService: NetworkManager()),
                                            weatherUseCase: WeatherUseCase(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext))

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var citiesTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        bindUI()
        weatherViewModel.fetchSavedWeatherData()
    }
    func setupUI(){
        titleLbl.textColor = .secondaryColor
    }
    func configureTableView() {
        citiesTV.register(UINib(nibName: "CitiesTVCell", bundle: nil), forCellReuseIdentifier: "CitiesTVCell")
    }
    func bindUI(){
        // bind add button
        addBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let SearchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC")
                present(SearchVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        // bind weather data
        weatherViewModel.savedWeatherData
//            .map { [weak self] weatherData -> [WeatherData] in
//                guard let self = self else { return [] }
//                if weatherData.cod?.intValue != 200{
//                    self.messageLbl.text = weatherData.message
//                    return []
//                }
//                return [weatherData]
//            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] data in
                guard let self = self else { return }
//                self.resultsTV.isHidden = data.isEmpty
//                self.messageLbl.isHidden = !data.isEmpty
            })
            .bind(to: citiesTV.rx.items(cellIdentifier: "CitiesTVCell", cellType: CitiesTVCell.self)) { row, savedWeatherData, cell in
                cell.selectionStyle = .none
                cell.savedWeatherData = savedWeatherData
            }
            .disposed(by: disposeBag)
    }
}
