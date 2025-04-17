//
//  HistoryVC.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryVC: UIViewController {
    
    let disposeBag = DisposeBag()
    var weatherViewModel = WeatherViewModel(weatherService: WeatherService(networkService: NetworkManager()),
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
    func setupUI(){
        titleLbl.textColor = .secondaryColor
    }
    func configureTableView() {
        citiesTV.register(UINib(nibName: "HistoryTVCell", bundle: nil), forCellReuseIdentifier: "HistoryTVCell")
    }
    func bindUI(){
        // bind add button
        addBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        // bind weather data
        weatherViewModel.cityHistory
            .compactMap { $0 }
            .do(onNext: { [weak self] grouped in
                guard let self = self else {return}
                self.titleLbl.text = "\(grouped.cityName)\n HISTORICAL"
            })
            .map { $0.weatherItems }
            .observe(on: MainScheduler.instance)
            .bind(to: citiesTV.rx.items(cellIdentifier: "HistoryTVCell", cellType: HistoryTVCell.self)) { row, historyData, cell in
                cell.selectionStyle = .none
                cell.historyData = historyData
            }
            .disposed(by: disposeBag)
    }
}
