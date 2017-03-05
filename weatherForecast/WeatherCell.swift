//
//  WeatherCell.swift
//  weatherForecast
//
//  Created by Vuk on 3/5/17.
//  Copyright © 2017 Vuk. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var weatherType: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    
    func configureCell(forecast: Forecast) {
        lowTempLabel.text = String(forecast.lowTemperature)
        highTempLabel.text = String(forecast.highTemperature)
        weatherType.text = forecast.weatherType
        weatherImage.image = UIImage(named: forecast.weatherType)
        dayLabel.text = forecast.date
    }
    
}
