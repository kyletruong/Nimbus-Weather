//
//  WeatherAPI.swift
//  Nimbus Weather
//
//  Created by Kyle Truong on 5/29/17.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

// create separate class for locationmanager
// instantiate in app delegate at startup

import Foundation
import CoreLocation
import GooglePlaces


protocol WeatherDelegate {
    func setWeather(_ weather: Weather)
    func setPlaceholder(_ placeholder: Placeholder)
}


class WeatherAPI {
    
    // VARS
    var delegate: WeatherDelegate?
    
    
    // FUNCTIONS
    // this get called for EVERY weather request. initial load, cur loc button, search bar req
    func getWeatherForLocation(_ location: CLLocationCoordinate2D) {
        let appid = "a138c2ff24bac0f86fce289926069892"
        let lat: Double
        let lon: Double
        
        switch location.latitude {
        case -99999 ..< -0.001:
            lat = location.latitude
        case -0.001 ..< 0.001:
            lat = 0
        case 0.001 ..< 99999:
            lat = location.latitude
        default:
            lat = 37.7749
        }
        
        switch location.longitude {
        case -99999 ..< -0.001:
            lon = location.longitude
        case -0.001 ..< 0.001:
            lon = 0
        case 0.001 ..< 99999:
            lon = location.longitude
        default:
            lon = -122.4194
        }
   
        let path = "https://api.darksky.net/forecast/\(appid)/\(lat),\(lon)"
        getWeatherFor(path)
        
        print("lat: \(lat)")
        print("lon: \(lon)")
    }
    
    func getWeatherFor(_ path: String) {
        
        let url = URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if let e = error {
                print("Error occurred: \(e)")
            }
            
            
            let json = JSON(data!)

            
            // JSON for current forecast
            let hourZeroTemp = json["currently"]["temperature"].double
            let hourZeroSummary = json["currently"]["summary"].string
            let hourZeroIcon = json["currently"]["icon"].string
            let dayZeroSummary = json["hourly"]["summary"].string
            let offset = json["offset"].double
            let dayZeroLow = json["daily"]["data"][0]["temperatureMin"].double
            let dayZeroHigh = json["daily"]["data"][0]["temperatureMax"].double
            
            
            
            // JSON for hourly forecast
            let hourZero = json["currently"]["time"].double
            let hourOne = json["hourly"]["data"][1]["time"].double
            let hourTwo = json["hourly"]["data"][2]["time"].double
            let hourThree = json["hourly"]["data"][3]["time"].double
            let hourFour = json["hourly"]["data"][4]["time"].double
            let hourFive = json["hourly"]["data"][5]["time"].double
            let hourSix = json["hourly"]["data"][6]["time"].double
            let hourSeven = json["hourly"]["data"][7]["time"].double
            let hourEight = json["hourly"]["data"][8]["time"].double
            let hourNine = json["hourly"]["data"][9]["time"].double
            let hourTen = json["hourly"]["data"][10]["time"].double
            let hourEleven = json["hourly"]["data"][11]["time"].double
            let hourTwelve = json["hourly"]["data"][12]["time"].double
            let hourThirteen = json["hourly"]["data"][13]["time"].double
            let hourFourteen = json["hourly"]["data"][14]["time"].double
            let hourFifteen = json["hourly"]["data"][15]["time"].double
            let hourSixteen = json["hourly"]["data"][16]["time"].double
            let hourSeventeen = json["hourly"]["data"][17]["time"].double
            let hourEighteen = json["hourly"]["data"][18]["time"].double
            let hourNineteen = json["hourly"]["data"][19]["time"].double
            let hourTwenty = json["hourly"]["data"][20]["time"].double
            let hourTwentyOne = json["hourly"]["data"][21]["time"].double
            let hourTwentyTwo = json["hourly"]["data"][22]["time"].double
            let hourTwentyThree = json["hourly"]["data"][23]["time"].double
            let hourTwentyFour = json["hourly"]["data"][24]["time"].double
            
            let hourOneIcon = json["hourly"]["data"][1]["icon"].string
            let hourTwoIcon = json["hourly"]["data"][2]["icon"].string
            let hourThreeIcon = json["hourly"]["data"][3]["icon"].string
            let hourFourIcon = json["hourly"]["data"][4]["icon"].string
            let hourFiveIcon = json["hourly"]["data"][5]["icon"].string
            let hourSixIcon = json["hourly"]["data"][6]["icon"].string
            let hourSevenIcon = json["hourly"]["data"][7]["icon"].string
            let hourEightIcon = json["hourly"]["data"][8]["icon"].string
            let hourNineIcon = json["hourly"]["data"][9]["icon"].string
            let hourTenIcon = json["hourly"]["data"][10]["icon"].string
            let hourElevenIcon = json["hourly"]["data"][11]["icon"].string
            let hourTwelveIcon = json["hourly"]["data"][12]["icon"].string
            let hourThirteenIcon = json["hourly"]["data"][13]["icon"].string
            let hourFourteenIcon = json["hourly"]["data"][14]["icon"].string
            let hourFifteenIcon = json["hourly"]["data"][15]["icon"].string
            let hourSixteenIcon = json["hourly"]["data"][16]["icon"].string
            let hourSeventeenIcon = json["hourly"]["data"][17]["icon"].string
            let hourEighteenIcon = json["hourly"]["data"][18]["icon"].string
            let hourNineteenIcon = json["hourly"]["data"][19]["icon"].string
            let hourTwentyIcon = json["hourly"]["data"][20]["icon"].string
            let hourTwentyOneIcon = json["hourly"]["data"][21]["icon"].string
            let hourTwentyTwoIcon = json["hourly"]["data"][22]["icon"].string
            let hourTwentyThreeIcon = json["hourly"]["data"][23]["icon"].string
            let hourTwentyFourIcon = json["hourly"]["data"][24]["icon"].string
            
            let hourOneTemp = json["hourly"]["data"][1]["temperature"].double
            let hourTwoTemp = json["hourly"]["data"][2]["temperature"].double
            let hourThreeTemp = json["hourly"]["data"][3]["temperature"].double
            let hourFourTemp = json["hourly"]["data"][4]["temperature"].double
            let hourFiveTemp = json["hourly"]["data"][5]["temperature"].double
            let hourSixTemp = json["hourly"]["data"][6]["temperature"].double
            let hourSevenTemp = json["hourly"]["data"][7]["temperature"].double
            let hourEightTemp = json["hourly"]["data"][8]["temperature"].double
            let hourNineTemp = json["hourly"]["data"][9]["temperature"].double
            let hourTenTemp = json["hourly"]["data"][10]["temperature"].double
            let hourElevenTemp = json["hourly"]["data"][11]["temperature"].double
            let hourTwelveTemp = json["hourly"]["data"][12]["temperature"].double
            let hourThirteenTemp = json["hourly"]["data"][13]["temperature"].double
            let hourFourteenTemp = json["hourly"]["data"][14]["temperature"].double
            let hourFifteenTemp = json["hourly"]["data"][15]["temperature"].double
            let hourSixteenTemp = json["hourly"]["data"][16]["temperature"].double
            let hourSeventeenTemp = json["hourly"]["data"][17]["temperature"].double
            let hourEighteenTemp = json["hourly"]["data"][18]["temperature"].double
            let hourNineteenTemp = json["hourly"]["data"][19]["temperature"].double
            let hourTwentyTemp = json["hourly"]["data"][20]["temperature"].double
            let hourTwentyOneTemp = json["hourly"]["data"][21]["temperature"].double
            let hourTwentyTwoTemp = json["hourly"]["data"][22]["temperature"].double
            let hourTwentyThreeTemp = json["hourly"]["data"][23]["temperature"].double
            let hourTwentyFourTemp = json["hourly"]["data"][24]["temperature"].double

            
            
            
            // JSON for 7 day forecast
            let dayOne = json["daily"]["data"][1]["time"].double
            let dayTwo = json["daily"]["data"][2]["time"].double
            let dayThree = json["daily"]["data"][3]["time"].double
            let dayFour = json["daily"]["data"][4]["time"].double
            let dayFive = json["daily"]["data"][5]["time"].double
            let daySix = json["daily"]["data"][6]["time"].double
            let daySeven = json["daily"]["data"][7]["time"].double
            
            let dayOneHigh = json["daily"]["data"][1]["temperatureMax"].double
            let dayOneLow = json["daily"]["data"][1]["temperatureMin"].double
            let dayTwoHigh = json["daily"]["data"][2]["temperatureMax"].double
            let dayTwoLow = json["daily"]["data"][2]["temperatureMin"].double
            let dayThreeHigh = json["daily"]["data"][3]["temperatureMax"].double
            let dayThreeLow = json["daily"]["data"][3]["temperatureMin"].double
            let dayFourHigh = json["daily"]["data"][4]["temperatureMax"].double
            let dayFourLow = json["daily"]["data"][4]["temperatureMin"].double
            let dayFiveHigh = json["daily"]["data"][5]["temperatureMax"].double
            let dayFiveLow = json["daily"]["data"][5]["temperatureMin"].double
            let daySixHigh = json["daily"]["data"][6]["temperatureMax"].double
            let daySixLow = json["daily"]["data"][6]["temperatureMin"].double
            let daySevenHigh = json["daily"]["data"][7]["temperatureMax"].double
            let daySevenLow = json["daily"]["data"][7]["temperatureMin"].double
            
            let dayOneIcon = json["daily"]["data"][1]["icon"].string
            let dayTwoIcon = json["daily"]["data"][2]["icon"].string
            let dayThreeIcon = json["daily"]["data"][3]["icon"].string
            let dayFourIcon = json["daily"]["data"][4]["icon"].string
            let dayFiveIcon = json["daily"]["data"][5]["icon"].string
            let daySixIcon = json["daily"]["data"][6]["icon"].string
            let daySevenIcon = json["daily"]["data"][7]["icon"].string
            
            
            
            // JSON for ALTERNATIVE FACTS
            var sunriseZero = json["daily"]["data"][0]["sunriseTime"].double
            var sunsetZero = json["daily"]["data"][0]["sunsetTime"].double
            var sunriseOne = json["daily"]["data"][1]["sunriseTime"].double
            var sunsetOne = json["daily"]["data"][1]["sunsetTime"].double
            let rainChance = json["daily"]["data"][0]["precipProbability"].double
            let rainIntensity = json["daily"]["data"][0]["precipIntensityMax"].double
            let humidity = json["currently"]["humidity"].double
            let wind = json["currently"]["windSpeed"].double
            let ozone = json["currently"]["ozone"].double
            let pressure = json["currently"]["pressure"].double
            let moonPhase = json["daily"]["data"][0]["moonPhase"].double
            let uvIndex = json["currently"]["uvIndex"].double
            
            
            
            // Checking for sunrise or sunset data. At high latitudes there are no sunrises or sunsets.
            if sunriseZero != nil {
                print("There is a sunrise today")
            } else {
                sunriseZero = 0
            }
            if sunsetZero != nil {
                print("There is a sunset today")
            } else {
                sunsetZero = 0
            }
            if sunriseOne != nil {
                print("There is a sunrise tomorrow")
            } else {
                sunriseOne = 0
            }
            if sunsetOne != nil {
                print("There is a sunset tomorrow")
            } else {
                sunsetOne = 0
            }
            
            
            
            
            
            let weather = Weather(// current forecast
                                  hourZeroTemp: hourZeroTemp!,
                                  hourZeroSummary: hourZeroSummary!,
                                  hourZeroIcon: hourZeroIcon!,
                                  dayZeroSummary: dayZeroSummary!,
                                  offset: offset!,
                                  dayZeroLow: dayZeroLow!,
                                  dayZeroHigh: dayZeroHigh!,
                                  
                                  
                                  // 24 hour forecast
                                  hourZero: hourZero!,
                                  hourOne: hourOne!,
                                  hourTwo: hourTwo!,
                                  hourThree: hourThree!,
                                  hourFour: hourFour!,
                                  hourFive: hourFive!,
                                  hourSix: hourSix!,
                                  hourSeven: hourSeven!,
                                  hourEight: hourEight!,
                                  hourNine: hourNine!,
                                  hourTen: hourTen!,
                                  hourEleven: hourEleven!,
                                  hourTwelve: hourTwelve!,
                                  hourThirteen: hourThirteen!,
                                  hourFourteen: hourFourteen!,
                                  hourFifteen: hourFifteen!,
                                  hourSixteen: hourSixteen!,
                                  hourSeventeen: hourSeventeen!,
                                  hourEighteen: hourEighteen!,
                                  hourNineteen: hourNineteen!,
                                  hourTwenty: hourTwenty!,
                                  hourTwentyOne: hourTwentyOne!,
                                  hourTwentyTwo: hourTwentyTwo!,
                                  hourTwentyThree: hourTwentyThree!,
                                  hourTwentyFour: hourTwentyFour!,
                                  
                                  hourOneIcon: hourOneIcon!,
                                  hourTwoIcon: hourTwoIcon!,
                                  hourThreeIcon: hourThreeIcon!,
                                  hourFourIcon: hourFourIcon!,
                                  hourFiveIcon: hourFiveIcon!,
                                  hourSixIcon: hourSixIcon!,
                                  hourSevenIcon: hourSevenIcon!,
                                  hourEightIcon: hourEightIcon!,
                                  hourNineIcon: hourNineIcon!,
                                  hourTenIcon: hourTenIcon!,
                                  hourElevenIcon: hourElevenIcon!,
                                  hourTwelveIcon: hourTwelveIcon!,
                                  hourThirteenIcon: hourThirteenIcon!,
                                  hourFourteenIcon: hourFourteenIcon!,
                                  hourFifteenIcon: hourFifteenIcon!,
                                  hourSixteenIcon: hourSixteenIcon!,
                                  hourSeventeenIcon: hourSeventeenIcon!,
                                  hourEighteenIcon: hourEighteenIcon!,
                                  hourNineteenIcon: hourNineteenIcon!,
                                  hourTwentyIcon: hourTwentyIcon!,
                                  hourTwentyOneIcon: hourTwentyOneIcon!,
                                  hourTwentyTwoIcon: hourTwentyTwoIcon!,
                                  hourTwentyThreeIcon: hourTwentyThreeIcon!,
                                  hourTwentyFourIcon: hourTwentyFourIcon!,
                                  
                                  hourOneTemp: hourOneTemp!,
                                  hourTwoTemp: hourTwoTemp!,
                                  hourThreeTemp: hourThreeTemp!,
                                  hourFourTemp: hourFourTemp!,
                                  hourFiveTemp: hourFiveTemp!,
                                  hourSixTemp: hourSixTemp!,
                                  hourSevenTemp: hourSevenTemp!,
                                  hourEightTemp: hourEightTemp!,
                                  hourNineTemp: hourNineTemp!,
                                  hourTenTemp: hourTenTemp!,
                                  hourElevenTemp: hourElevenTemp!,
                                  hourTwelveTemp: hourTwelveTemp!,
                                  hourThirteenTemp: hourThirteenTemp!,
                                  hourFourteenTemp: hourFourteenTemp!,
                                  hourFifteenTemp: hourFifteenTemp!,
                                  hourSixteenTemp: hourSixteenTemp!,
                                  hourSeventeenTemp: hourSeventeenTemp!,
                                  hourEighteenTemp: hourEighteenTemp!,
                                  hourNineteenTemp: hourNineteenTemp!,
                                  hourTwentyTemp: hourTwentyTemp!,
                                  hourTwentyOneTemp: hourTwentyOneTemp!,
                                  hourTwentyTwoTemp: hourTwentyTwoTemp!,
                                  hourTwentyThreeTemp: hourTwentyThreeTemp!,
                                  hourTwentyFourTemp: hourTwentyFourTemp!,



                                  
                                  // 7 day forecast
                                  dayOne: dayOne!,
                                  dayTwo: dayTwo!,
                                  dayThree: dayThree!,
                                  dayFour: dayFour!,
                                  dayFive: dayFive!,
                                  daySix: daySix!,
                                  daySeven: daySeven!,
                                  
                                  dayOneHigh: dayOneHigh!,
                                  dayOneLow: dayOneLow!,
                                  dayTwoHigh: dayTwoHigh!,
                                  dayTwoLow: dayTwoLow!,
                                  dayThreeHigh: dayThreeHigh!,
                                  dayThreeLow: dayThreeLow!,
                                  dayFourHigh: dayFourHigh!,
                                  dayFourLow: dayFourLow!,
                                  dayFiveHigh: dayFiveHigh!,
                                  dayFiveLow: dayFiveLow!,
                                  daySixHigh: daySixHigh!,
                                  daySixLow: daySixLow!,
                                  daySevenHigh: daySevenHigh!,
                                  daySevenLow: daySevenLow!,
                                  
                                  dayOneIcon: dayOneIcon!,
                                  dayTwoIcon: dayTwoIcon!,
                                  dayThreeIcon: dayThreeIcon!,
                                  dayFourIcon: dayFourIcon!,
                                  dayFiveIcon: dayFiveIcon!,
                                  daySixIcon: daySixIcon!,
                                  daySevenIcon: daySevenIcon!,
                                  
                                  // alternative fax
                                  sunriseZero: sunriseZero!,
                                  sunsetZero: sunsetZero!,
                                  sunriseOne: sunriseOne!,
                                  sunsetOne: sunsetOne!,
                                  
                                  rainChance: rainChance!,
                                  rainIntensity: rainIntensity!,
                                  humidity: humidity!,
                                  wind: wind!,
                                  ozone: ozone!,
                                  pressure: pressure!,
                                  moonPhase: moonPhase!,
                                  uvIndex: uvIndex!
                                  )
            
            
            
            
            
            if let delegate = self.delegate {
                DispatchQueue.main.async {
                    delegate.setWeather(weather)
                }
            }
        }
        
        task.resume()
    }
    
    // made this JUST so i can update placeholder in searchbar bc darsky doesn't give city names...
    func getWeatherForPlaceholder(_ location: CLLocation) {
        let appid = "0541841befdc83ef77fab1c9ec0071c3"
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)"
        
        let url = URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if let e = error {
                print("Error occurred: \(e)")
            }
            
            
            let json = JSON(data!)
            
            let name = json["name"].string
            
            let placeholder = Placeholder(cityName: name!)
            
            if let delegate = self.delegate {
                DispatchQueue.main.async {
                    delegate.setPlaceholder(placeholder)
                }
            }
        }
        task.resume()
    }
}
