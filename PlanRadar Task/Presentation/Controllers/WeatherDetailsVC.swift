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

    @IBOutlet weak var informationLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    func setupUI(){
        titleLbl.textColor = .secondaryColor
    }
    func bindUI(){
        // bind add button
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
}
