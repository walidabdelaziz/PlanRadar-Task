//
//  HistoryTVCell.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit

class HistoryTVCell: UITableViewCell {
    
    var historyData: WeatherInfo? {
        didSet {
            guard let historyData = historyData else { return }
            titleLbl.text = "\(historyData.desc ?? ""), \(historyData.temperature.toCelsiusString)"
            dateLbl.text = historyData.date?.toString(format: "dd.MM.yyyy - HH:mm")

        }
    }

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.textColor = .primaryColor
        dateLbl.textColor = .secondaryColor
    }
}
