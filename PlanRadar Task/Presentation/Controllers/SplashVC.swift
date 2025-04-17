//
//  SplashVC.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit

class SplashVC: UIViewController {
    
    var count = 2
    var timer: Timer?
    
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    func setupUI(){
        titleLbl.textColor = .PrimaryColor
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    @objc func updateUI(){
        if count > 0 {
            count -= 1
        }else{
            showVC()
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    @objc func showVC(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let MainVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
//        navigationController?.pushViewController(MainVC, animated: true)
    }
}
