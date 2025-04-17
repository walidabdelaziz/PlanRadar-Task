//
//  SearchVC.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController {

    var onConfirm: ((Bool) -> Void)?
    let disposeBag = DisposeBag()
    let weatherViewModel = WeatherViewModel(weatherService: WeatherService(networkService: NetworkManager()),
                                            weatherUseCase: WeatherUseCase(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext))

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var resultsTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTextField()
        configureTableView()
        bindUI()
    }
    func setupUI(){
        titleLbl.textColor = .secondaryColor
        cancelBtn.setTitleColor(.primaryColor, for: .normal)
    }
    func configureTextField(){
        searchTF.layer.cornerRadius = 8
        searchTF.backgroundColor = .lightGrayColor
        searchTF.paddingLeft(padding: 28)
        searchTF.paddingRight(padding: 8)
    }
    func configureTableView() {
        resultsTV.register(UINib(nibName: "CitiesTVCell", bundle: nil), forCellReuseIdentifier: "CitiesTVCell")
    }
    func bindUI(){
        // bind loader indicator
        weatherViewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.view.showLoader() : self.view.hideLoader()
            })
            .disposed(by: disposeBag)
        
        // bind cancel button
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.onConfirm!(false)
            }).disposed(by: disposeBag)
        
        // bind search text field
        searchTF.rx.text.orEmpty
            .debounce(.milliseconds(600), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else {return}
                if text.isEmpty {
                    self.resultsTV.isHidden = true
                    self.messageLbl.isHidden = true
                } else {
                    self.weatherViewModel.getWeatherData(searchText: text)
                }
            })
            .disposed(by: disposeBag)
        
        // bind weather data
        weatherViewModel.weatherData
            .map { [weak self] weatherData -> [WeatherData] in
                guard let self = self else { return [] }
                if weatherData.cod?.intValue != 200{
                    self.messageLbl.text = weatherData.message
                    return []
                }
                return [weatherData]
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] data in
                guard let self = self else { return }
                self.resultsTV.isHidden = data.isEmpty
                self.messageLbl.isHidden = !data.isEmpty
            })
            .bind(to: resultsTV.rx.items(cellIdentifier: "CitiesTVCell", cellType: CitiesTVCell.self)) { row, weatherData, cell in
                cell.selectionStyle = .none
                cell.weatherData = weatherData
            }
            .disposed(by: disposeBag)
        
        // handle tableview selection
        Observable.zip(
            resultsTV.rx.modelSelected(WeatherData.self),
            resultsTV.rx.itemSelected
        )
        .subscribe(onNext: { [weak self] weatherData, indexPath in
            guard let self = self else { return }
            self.weatherViewModel.saveWeatherData(weatherData: weatherData)
            self.onConfirm!(true)
        })
        .disposed(by: disposeBag)
    }
}
