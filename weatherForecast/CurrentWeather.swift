//
//  CurrentWeather.swift
//  weatherForecast
//
//  Created by Vuk on 3/5/17.
//  Copyright © 2017 Vuk. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    //ovo radim zbog skrivanja podataka, tj zbog enkapsulacije podataka, s druge strane na ovaj nacin se osiguravam da mi je kod bezbedan jer u slucaju api responsa koji je nil, app moze da mi pukne, a ja necu to, tako da necu dati da mi response bude nil, nego ce biti barem nesto (npr prazan string)
    
    var _cityName: String?
    var _date: String?
    var _weatherType: String?
    var _currentTemp: Double?
    var _imageType: String?
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName!
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.timeStyle = .none
        let currentDate = dateFormatter1.string(from: Date())
        //self._date = "Danas, \(currentDate)"
        
        let unixConvertedDate = Date()
        let dateForematter2 = DateFormatter()
        dateForematter2.dateStyle = .full
        dateForematter2.dateFormat = "EEEE"
        dateForematter2.timeStyle = .none
        let translated: String = String(describing: translateDay(rawValue: unixConvertedDate.dayOfTheWeek()))
        self._date = "\(translated), \(currentDate)"
        
        return _date!
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType!
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp!
    }
    
    var imageType: String {
        if _imageType == nil {
            _imageType = ""
        }
        return _imageType!
    }
    
        
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
       
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { (response) in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName!)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {
                    if let main = weather[0]["main"] as? String {
        
                        let translated: String = String(describing: translate(rawValue: main))
                        self._weatherType = translated
                        self._imageType = main
                        print(self._weatherType!)
                        print(self._imageType!)
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String,AnyObject> {
                    
                    if let currentTemp = main["temp"] as? Double {
                        let celsiusTemp = round(currentTemp - 273.15) 
                        self._currentTemp = celsiusTemp
                        print(self._currentTemp!)
                    }
                }
            }
        completed() //mora se staviti unutar Alamofire bloka
        }
        
    }
}
