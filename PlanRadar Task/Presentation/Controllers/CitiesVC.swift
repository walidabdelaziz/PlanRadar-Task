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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherViewModel.fetchSavedCities()
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
                let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
                searchVC.onConfirm = {[weak self] confirmed in
                    guard let self = self else{return}
                    self.dismiss(animated: true){
                        if confirmed {
                            self.weatherViewModel.fetchSavedCities()
                        }
                    }
                }
                present(searchVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        // bind weather data
        weatherViewModel.savedCities
            .observe(on: MainScheduler.instance)
            .bind(to: citiesTV.rx.items(cellIdentifier: "CitiesTVCell", cellType: CitiesTVCell.self)) { row, savedWeatherData, cell in
                cell.selectionStyle = .none
                cell.historyBtn.tag = row
                cell.historyDelegate = self
                cell.savedWeatherData = savedWeatherData
            }
            .disposed(by: disposeBag)
        
        // handle tableview selection
        citiesTV.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                weatherViewModel.selectCityWeatherHistory(index: indexPath.row)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let weatherDetailsVC = storyboard.instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherDetailsVC
                weatherDetailsVC.weatherViewModel = self.weatherViewModel
                self.navigationController?.pushViewController(weatherDetailsVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
extension CitiesVC: HistoryProtocol {
    func didPressHistoryBtn(_ sender: UIButton) {
        weatherViewModel.selectCityWeatherHistory(index: sender.tag)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        historyVC.weatherViewModel = weatherViewModel
        present(historyVC, animated: true, completion: nil)
    }
}
