//
//  WeatherVC.swift
//  weatherForecast
//
//  Created by Vuk on 3/4/17.
//  Copyright © 2017 Vuk. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var currentWeatherImage: UIImageView!
    @IBOutlet var currentWeatherTypeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var currentWeather: CurrentWeather?
    var forecastWeather: Forecast?
    var forecasts = [Forecast]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        currentWeather = CurrentWeather()
        
        //ovo sam odavde morao da sklonim jer je pucala app u Constants u CURRENT_WEATHER_URL, i da prebacim u VIEW_DID_APPEAR, jer tek tamo Loaction.sharedLocation.latitutde i longitude dobijaju svoje vrednosti
        //Na ovom mestu nema sta da se ubaci u CURRENT_WEATHER_URL koja se preko VIEW_DID_LOAD-a, koristila pre nego sto su joj vrednosti stigle, i imale su samo nil-ove
        
//        currentWeather?.downloadWeatherDetails {
//            self.downloadForecastDetails {
//                self.updateMainUI()
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) { // DidAppear se desava posle nego zavrsetka download-a, tj posle DidLoad-a
        super.viewDidAppear(animated)
        locationAuthorizationStatus()
    }
    
    func locationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { //AKO SAM DOZVOLIO PRONALAZENJE LOKACIJE
            currentLocation = locationManager.location
            Location.sharedLocation.latitude = currentLocation?.coordinate.latitude
            Location.sharedLocation.longitude = currentLocation?.coordinate.longitude
            
            currentWeather?.downloadWeatherDetails {
                self.downloadForecastDetails {
                    self.updateMainUI()
                }
            }
        } else { //AKO NISAM, PITAJ ME DA DOZVOLIM I OPET PONOVI PITANJE DA NE BI PROSLO DALJE BEZ MOJE POTVRDE
            locationManager.requestWhenInUseAuthorization()
            locationAuthorizationStatus()
        }
    }

    func downloadForecastDetails(completed: @escaping DownloadComplete) {
    
        Alamofire.request(FORECAST_WEATHER_URL).responseJSON { (response) in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject> {
                if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                    for element in list {
                        let forecast = Forecast(weatherDict: element)
                        self.forecasts.append(forecast)
                        print(element)
                    }
                    self.forecasts.remove(at: 0) // ovo sam uradio da bi u tabeli bili prikazani dani od sutrašnjeg u odnosu na onaj koji je u glavnoj (trenutnoj) prognozi
                    self.tableView.reloadData() //posle zavrsetka petlje,odnosno punjenja niza forecasts, hocu da se tabela osvezi
                }
            }
            completed()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row] //uzima element svakog indexa niza forecasts ponaosob i dodelice ga svakom redu tabele (u sledecm redu koda)
            cell.configureCell(forecast: forecast) //s obzirom da sam downcastovao cell po mojoj WeatherCell klasi, ovim, svakom UI elementu celije dajem vrednost
            return cell
        } else {
            return WeatherCell() // ako se ovo gore iz nekog razloga ne ostvari, vrati mi praznu celiju tipa WeatherCell
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather?.date
        currentTempLabel.text = String(describing: currentWeather!.currentTemp)
        locationLabel.text = currentWeather?.cityName
        currentWeatherTypeLabel.text = currentWeather?.weatherType
        currentWeatherImage.image = UIImage(named: (currentWeather?.imageType)!)
    }
}

