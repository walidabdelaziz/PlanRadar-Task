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
            .observe(on: MainScheduler.instance)
            .bind(to: citiesTV.rx.items(cellIdentifier: "CitiesTVCell", cellType: CitiesTVCell.self)) { row, savedWeatherData, cell in
                cell.selectionStyle = .none
                cell.historyBtn.tag = row
                cell.historyDelegate = self
                cell.savedWeatherData = savedWeatherData
            }
            .disposed(by: disposeBag)
    }
}
extension CitiesVC: HistoryProtocol {
    func didPressHistoryBtn(_ sender: UIButton) {
        weatherViewModel.cityHistory.accept(weatherViewModel.savedWeatherData.value[sender.tag])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        historyVC.weatherViewModel = weatherViewModel
        present(historyVC, animated: true, completion: nil)
    }
}
