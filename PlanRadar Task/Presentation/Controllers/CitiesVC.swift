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
    }
}
