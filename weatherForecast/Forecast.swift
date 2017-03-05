//
//  Forecast.swift
//  weatherForecast
//
//  Created by Vuk on 3/5/17.
//  Copyright © 2017 Vuk. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {

    var _date: String?
    var _weatherType: String?
    var _imageType: String?
    var _highTemperature: Double?
    var _lowTemperature: Double?
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date!
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType!
    }
    
    var imageType: String {
        if _imageType == nil {
            _imageType = ""
        }
        return _imageType!
    }
    
    var highTemperature: Double {
        if _highTemperature == nil {
            _highTemperature = 0.0
        }
        return _highTemperature!
    }
    
    var lowTemperature: Double {
        if _lowTemperature == nil {
            _lowTemperature = 0.0
        }
        return _lowTemperature!
    }
    
    init(weatherDict: Dictionary<String,AnyObject>) {
        if let temp = weatherDict["temp"] as? Dictionary<String,AnyObject> {
            if let min = temp["min"] as? Double {
                let celsiusTemp = round(min - 273.15)
                self._lowTemperature = celsiusTemp
                print(self._lowTemperature!)
            }
            if let max = temp["max"] as? Double {
                let celsiusTemp = round(max - 273.15)
                self._highTemperature = celsiusTemp
                print(self._highTemperature!)
            }
        }
        if let weather = weatherDict["weather"] as? [Dictionary<String,AnyObject>] {
            if let main = weather[0]["main"] as? String {
                let translated: String = String(describing: translate(rawValue: main))
                self._weatherType = translated
                self._imageType = main
                print(self._weatherType!)
                print(self._imageType!)
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateForematter = DateFormatter()
            dateForematter.dateStyle = .full
            dateForematter.dateFormat = "EEEE"
            dateForematter.timeStyle = .none
            let translated: String = String(describing: translateDay(rawValue: unixConvertedDate.dayOfTheWeek()))
            self._date = translated
        }
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
