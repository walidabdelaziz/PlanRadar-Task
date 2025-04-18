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
        weatherViewModel.fetchWeatherDetails()
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
        // bind add button
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // bind labels and icons
        weatherViewModel.cityHistory
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                self.titleLbl.text = "\(info.cityName) \(info.countryCode)"
                self.informationLbl.text = "WEATHER INFORMATION FOR \(info.cityName.uppercased()) RECEIVED ON \n\(info.weatherItems.first?.date?.toString(format: "dd.MM.yyyy - HH:mm") ?? "")"
                let iconURL = String(format: Constants.WEATHER_ICON, info.weatherItems.first?.icon ?? "")
                self.weatherIcon.setImageFromUrl(imageStr: iconURL)
            })
            .disposed(by: disposeBag)
        
        // bind weather data
        weatherViewModel.weatherAttributes
            .observe(on: MainScheduler.instance)
            .bind(to: detailsTV.rx.items(cellIdentifier: "WeatherAttributesTVCell", cellType: WeatherAttributesTVCell.self)) { row, weatherAttribute, cell in
                cell.selectionStyle = .none
                cell.weatherAttribute = weatherAttribute
            }
            .disposed(by: disposeBag)
    }
}
