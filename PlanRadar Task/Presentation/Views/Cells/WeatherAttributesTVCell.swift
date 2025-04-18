//
//  WeatherAttributesTVCell.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 18/04/2025.
//

import UIKit

class WeatherAttributesTVCell: UITableViewCell {

    var weatherAttribute: WeatherDetailItem? {
        didSet {
            guard let weatherAttribute = weatherAttribute else { return }
            keyLbl.text = weatherAttribute.key
            valueLbl.text = weatherAttribute.value
        }
    }
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var keyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        keyLbl.textColor = .secondaryColor
        valueLbl.textColor = .primaryColor
    }
}
