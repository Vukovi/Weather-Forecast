//
//  Constants.swift
//  weatherForecast
//
//  Created by Vuk on 3/5/17.
//  Copyright © 2017 Vuk. All rights reserved.
//

import Foundation

// http://api.openweathermap.org/data/2.5/weather?lat=42&lon=44&appid=ee0c71d0835abe30237abfabc36d97bc

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let APP_KEY = "ee0c71d0835abe30237abfabc36d97bc"

typealias DownloadComplete = () -> () //ovo ce mojoj f-ji reci da je njen download zavrsen

//let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)44.787197\(LONGITUDE)20.457273\(APP_ID)\(APP_KEY)"   //hardkodirano
let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedLocation.latitude!)&lon=\(Location.sharedLocation.longitude!)&appid=ee0c71d0835abe30237abfabc36d97bc"
let FORECAST_WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedLocation.latitude!)&lon=\(Location.sharedLocation.longitude!)&cnt=10&appid=ee0c71d0835abe30237abfabc36d97bc"

enum WeatherTranslate: String {
    case Vedro = "Clear", Oblačno = "Clouds", Kiša = "Rain", Sneg = "Snow", None = ""
}

func translate(rawValue:String) -> WeatherTranslate {
    if let translated = WeatherTranslate(rawValue: rawValue) {
        return translated
    } else{
        return .None
    }
}

enum DaysTranslate: String {
    case Ponedeljak = "Monday", Utorak = "Tuesday", Sreda = "Wednesday", Četvrtak = "Thursday", Petak = "Friday", Subota = "Saturday", Nedelja = "Sunday", None = ""
}

func translateDay(rawValue:String) -> DaysTranslate {
    if let translated = DaysTranslate(rawValue: rawValue) {
        return translated
    }else{
        return .None
    }
}
