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

    let disposeBag = DisposeBag()

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTextField()
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
    func bindUI(){
        // bind cancel button
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
