//
//  Location.swift
//  weatherForecast
//
//  Created by Vuk on 3/5/17.
//  Copyright © 2017 Vuk. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    //pravim singleton klasu sledecim
    static var sharedLocation = Location() // statickoj promenljivoj se moze pristupiti iz bilo kog fajla app, kao da je ukupno globalna
    private init() {} //ali ovim je cinim jedinstvenom
    
    var latitude: Double!
    var longitude: Double!
}
