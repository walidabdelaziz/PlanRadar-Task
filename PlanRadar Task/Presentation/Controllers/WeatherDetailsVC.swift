//
//  WeatherDetailsVC.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 18/04/2025.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherDetailsVC: UIViewController {
    
    let disposeBag = DisposeBag()
    var weatherViewModel = WeatherViewModel(weatherService: WeatherService(networkService: NetworkManager()),
                                            weatherUseCase: WeatherUseCase(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext))

    @IBOutlet weak var detailsTVHeight: NSLayoutConstraint!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var detailsTV: UITableView!
    @IBOutlet weak var detailsbgV: UIView!
    @IBOutlet weak var informationLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        weatherViewModel.getWeatherData(searchText: weatherViewModel.selectedCityWeatherHistory.value?.cityName ?? "")
        bindUI()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize = newvalue as! CGSize
                detailsTVHeight.constant = newsize.height
            }
        }
    }
    func setupUI(){
        [titleLbl, informationLbl].forEach {
            $0?.textColor = .secondaryColor
        }
        detailsbgV.layer.cornerRadius = 32
        detailsbgV.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
    }
    func configureTableView() {
        detailsTV.register(UINib(nibName: "WeatherAttributesTVCell", bundle: nil), forCellReuseIdentifier: "WeatherAttributesTVCell")
        detailsTV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    func bindUI(){
        // bind loader indicator
        weatherViewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.view.showLoader() : self.view.hideLoader()
                self.detailsTV.isHidden = isLoading ? true : false
            })
            .disposed(by: disposeBag)
        
        // bind add button
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // bind weather data
        weatherViewModel.currentWeatherForCity
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] weatherData in
                guard let self = self else { return }
                self.updateUI(weatherData: weatherData)
                self.weatherViewModel.saveWeatherData(weatherData: weatherData)
                self.weatherViewModel.fetchWeatherAttributes()
            })
            .disposed(by: disposeBag)

        
        // bind weather attributes
        weatherViewModel.weatherAttributes
            .observe(on: MainScheduler.instance)
            .bind(to: detailsTV.rx.items(cellIdentifier: "WeatherAttributesTVCell", cellType: WeatherAttributesTVCell.self)) { row, weatherAttribute, cell in
                cell.selectionStyle = .none
                cell.weatherAttribute = weatherAttribute
            }
            .disposed(by: disposeBag)
    }
    func updateUI(weatherData: WeatherData){
        titleLbl.text = "\(weatherData.name ?? "") \(weatherData.sys?.country ?? "")"
        informationLbl.text = "WEATHER INFORMATION FOR \(weatherData.name?.uppercased() ?? "") RECEIVED ON \n\(Date().toString(format: "dd.MM.yyyy - HH:mm"))"
        let iconURL = String(format: Constants.WEATHER_ICON, weatherData.weather?.first?.icon ?? "")
        weatherIcon.setImageFromUrl(imageStr: iconURL)
    }
}
