//
//  ViewController.swift
//  Wasabi_Weather
//
//  Created by Kyle Truong on 5/29/17.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import SnapKit

class ViewController: UIViewController, WeatherDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {
    
    
    // VARIABLES
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let locationManager = CLLocationManager()
    let weatherService = WeatherAPI()
    let reachability = Reachability()!
    var hourlyScrollView = UIScrollView()
    var hourlyContainerView = UIView()
    var nimbusScrollView = UIScrollView()
    var nimbusContainerView = UIView()
    var headerView = UIView()
    var dayZeroSummary = UILabel()
    var loadingLabel = UILabel()
    let loadingCloud = SKYIconView()
    
    func loadingScreen(text: String, isHidden: Bool) {
        loadingLabel.text = text
        headerView.isHidden = isHidden
        nimbusScrollView.isHidden = isHidden
        loadingLabel.isHidden = !isHidden
        loadingCloud.isHidden = !isHidden
    }
    
    
    
    
    func setupHeaderView () {
        headerView.frame = CGRect(x: 0, y: 60, width: view.frame.size.width, height: 137)
        headerView.tag = 400
        view.addSubview(headerView)
    }
    
    func setupHourlyForecastView() {
        hourlyScrollView.delegate = self
        hourlyScrollView.contentSize = CGSize(width: 1425, height: 110)
        hourlyScrollView.frame = CGRect(x: 0, y: 357, width: view.frame.size.width, height: 110)
        
        hourlyContainerView.frame = CGRect(x: 0, y: 0, width: hourlyScrollView.contentSize.width, height: hourlyScrollView.contentSize.height)
        
        hourlyScrollView.isScrollEnabled = true
        hourlyScrollView.showsHorizontalScrollIndicator = false
        
        hourlyScrollView.tag = 500
        hourlyContainerView.tag = 501
        
        view.viewWithTag(601)?.addSubview(hourlyScrollView)
        hourlyScrollView.addSubview(hourlyContainerView)
        
    }
    
    func setupScrollView () {
        nimbusScrollView.delegate = self
        nimbusScrollView.contentSize = CGSize(width: view.frame.size.width, height: 1100)
        nimbusScrollView.frame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: view.frame.size.height-200)
        
        nimbusContainerView.frame = CGRect(x: 0, y: 0, width: nimbusScrollView.contentSize.width, height: nimbusScrollView.contentSize.height)
        
        nimbusScrollView.isScrollEnabled = true
        nimbusScrollView.showsVerticalScrollIndicator = false
        
        nimbusScrollView.tag = 600
        nimbusContainerView.tag = 601
        
        nimbusContainerView.backgroundColor = UIColor(red: 93/255.0, green: 173/255.0, blue: 226/255.0, alpha: 1.0)
        
        
        nimbusScrollView.addSubview(nimbusContainerView)
        view.addSubview(nimbusScrollView)
    }
    

    
    
    
    func openAppSettingsAlert() {
        let alert = UIAlertController(title: "Allow Location Services", message: "Allow us to update the weather at your location automatically.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let settings = UIAlertAction(title: "Settings", style: .default) { (UIAlertAction) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alert.addAction(cancel)
        alert.addAction(settings)
        
        self.present(alert, animated: true, completion: nil)
    }

   
    func infoButtonPressed() {
        let alert = UIAlertController(title: "Questions? Comments? Concerns?", message: "Please feel free to email me at kyletruong@gmail.com", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(OK)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func curLocPressed () {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                openAppSettingsAlert()
            case .authorizedAlways, .authorizedWhenInUse:
                getGPSLocation()
            }
        } else {
            openAppSettingsAlert()
        }
    }
    
    
    
    // location methods
    
    func getGPSLocation() {
        
        locationManager.startUpdatingLocation()
        
        loadingScreen(text: "Loading...", isHidden: true)

    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        if locations.count > 0 {
            
            if reachability.isReachable {
                DispatchQueue.main.async {
                    self.weatherService.getWeatherForLocation(location)  // this updates all the info on initial load and cur loc button
                    self.weatherService.getWeatherForPlaceholder(locations[0])  // only updates only placeholder name on initial load and cur loc button
                    self.locationManager.stopUpdatingLocation()
                }
            } else {
                DispatchQueue.main.async {
                    print("no internet")
                    //self.loadingScreen(text: "Uh oh, your interwebs is down", isHidden: true)
                    self.loadingLabel.text = "Uh oh, your interwebs is down"
                    let textField = self.searchController?.searchBar.value(forKey: "searchField") as! UITextField
                    textField.attributedPlaceholder = NSAttributedString(string: "Try Adding City or ZIP Code", attributes: [NSForegroundColorAttributeName: UIColor.white])
                    self.locationManager.stopUpdatingLocation()
                }
            }
            
            
        }
        else {
            print("No locations found")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    // set weather func, the final func called at the end of every weather request.
    func setWeather(_ weather: Weather) {
        
        // current forecast variables
        var dayZeroLowLabel = UILabel()
        var dayZeroHighLabel = UILabel()
        var hourZeroSummaryLabel = UILabel()
        var hourZeroTempLabel = UILabel()
        
        
        // alternative fax variables
        let sunriseLabel = "Sunrise:"
        let sunsetLabel = "Sunset:"
        let rainChanceLabel = "Precipitation Chance:"
        let rainIntensityLabel = "Intensity:"
        let humidityLabel = "Humidity:"
        let windLabel = "Wind:"
        let ozoneLabel = "Ozone:"
        let pressureLabel = "Pressure:"
        let moonPhaseLabel = "Moon Phase:"
        let uvIndexLabel = "UV Index:"
        
        let sunriseData = UILabel()
        let sunsetData = UILabel()
        let moonPhaseData = UILabel()
        
        
        // 24 hour forecast
        
        let timeFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        let moreTimeFormatter = DateFormatter()
        
        
        dayFormatter.timeZone = TimeZone(identifier: "UTC")
        timeFormatter.timeZone = TimeZone(identifier: "UTC")
        moreTimeFormatter.timeZone = TimeZone(identifier: "UTC")
        
        timeFormatter.dateFormat = "ha"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        dayFormatter.dateFormat = "EEEE"
        moreTimeFormatter.dateFormat = "h:mm a"
        moreTimeFormatter.amSymbol = "AM"
        moreTimeFormatter.pmSymbol = "PM"


        let hourZeroUnix = NSDate(timeIntervalSince1970: (weather.hourZero + (weather.offset * 3600)))
        let hourOneUnix = NSDate(timeIntervalSince1970: (weather.hourOne + (weather.offset * 3600)))
        let hourTwoUnix = NSDate(timeIntervalSince1970: (weather.hourTwo + (weather.offset * 3600)))
        let hourThreeUnix = NSDate(timeIntervalSince1970: (weather.hourThree + (weather.offset * 3600)))
        let hourFourUnix = NSDate(timeIntervalSince1970: (weather.hourFour + (weather.offset * 3600)))
        let hourFiveUnix = NSDate(timeIntervalSince1970: (weather.hourFive + (weather.offset * 3600)))
        let hourSixUnix = NSDate(timeIntervalSince1970: (weather.hourSix + (weather.offset * 3600)))
        let hourSevenUnix = NSDate(timeIntervalSince1970: (weather.hourSeven + (weather.offset * 3600)))
        let hourEightUnix = NSDate(timeIntervalSince1970: (weather.hourEight + (weather.offset * 3600)))
        let hourNineUnix = NSDate(timeIntervalSince1970: (weather.hourNine + (weather.offset * 3600)))
        let hourTenUnix = NSDate(timeIntervalSince1970: (weather.hourTen + (weather.offset * 3600)))
        let hourElevenUnix = NSDate(timeIntervalSince1970: (weather.hourEleven + (weather.offset * 3600)))
        let hourTwelveUnix = NSDate(timeIntervalSince1970: (weather.hourTwelve + (weather.offset * 3600)))
        let hourThirteenUnix = NSDate(timeIntervalSince1970: (weather.hourThirteen + (weather.offset * 3600)))
        let hourFourteenUnix = NSDate(timeIntervalSince1970: (weather.hourFourteen + (weather.offset * 3600)))
        let hourFifteenUnix = NSDate(timeIntervalSince1970: (weather.hourFifteen + (weather.offset * 3600)))
        let hourSixteenUnix = NSDate(timeIntervalSince1970: (weather.hourSixteen + (weather.offset * 3600)))
        let hourSeventeenUnix = NSDate(timeIntervalSince1970: (weather.hourSeventeen + (weather.offset * 3600)))
        let hourEighteenUnix = NSDate(timeIntervalSince1970: (weather.hourEighteen + (weather.offset * 3600)))
        let hourNineteenUnix = NSDate(timeIntervalSince1970: (weather.hourNineteen + (weather.offset * 3600)))
        let hourTwentyUnix = NSDate(timeIntervalSince1970: (weather.hourTwenty + (weather.offset * 3600)))
        let hourTwentyOneUnix = NSDate(timeIntervalSince1970: (weather.hourTwentyOne + (weather.offset * 3600)))
        let hourTwentyTwoUnix = NSDate(timeIntervalSince1970: (weather.hourTwentyTwo + (weather.offset * 3600)))
        let hourTwentyThreeUnix = NSDate(timeIntervalSince1970: (weather.hourTwentyThree + (weather.offset * 3600)))
        let hourTwentyFourUnix = NSDate(timeIntervalSince1970: (weather.hourTwentyFour + (weather.offset * 3600)))
        
        // daily time
        let dayOneUnix = NSDate(timeIntervalSince1970: (weather.dayOne + (weather.offset * 3600)))
        let dayTwoUnix = NSDate(timeIntervalSince1970: (weather.dayTwo + (weather.offset * 3600)))
        let dayThreeUnix = NSDate(timeIntervalSince1970: (weather.dayThree + (weather.offset * 3600)))
        let dayFourUnix = NSDate(timeIntervalSince1970: (weather.dayFour + (weather.offset * 3600)))
        let dayFiveUnix = NSDate(timeIntervalSince1970: (weather.dayFive + (weather.offset * 3600)))
        let daySixUnix = NSDate(timeIntervalSince1970: (weather.daySix + (weather.offset * 3600)))
        let daySevenUnix = NSDate(timeIntervalSince1970: (weather.daySeven + (weather.offset * 3600)))

        
        

        
        
        //dayZero.text = "\(dayFormatter.string(from: hourZeroUnix as Date))"
        var dayOne = "\(dayFormatter.string(from: dayOneUnix as Date))"
        var dayTwo = "\(dayFormatter.string(from: dayTwoUnix as Date))"
        var dayThree = "\(dayFormatter.string(from: dayThreeUnix as Date))"
        var dayFour = "\(dayFormatter.string(from: dayFourUnix as Date))"
        var dayFive = "\(dayFormatter.string(from: dayFiveUnix as Date))"
        var daySix = "\(dayFormatter.string(from: daySixUnix as Date))"
        var daySeven = "\(dayFormatter.string(from: daySevenUnix as Date))"
        
        var dayOneHigh = "\(Int(weather.dayOneHigh))"
        var dayOneLow = "\(Int(weather.dayOneLow))"
        var dayTwoHigh = "\(Int(weather.dayTwoHigh))"
        var dayTwoLow = "\(Int(weather.dayTwoLow))"
        var dayThreeHigh = "\(Int(weather.dayThreeHigh))"
        var dayThreeLow = "\(Int(weather.dayThreeLow))"
        var dayFourHigh = "\(Int(weather.dayFourHigh))"
        var dayFourLow = "\(Int(weather.dayFourLow))"
        var dayFiveHigh = "\(Int(weather.dayFiveHigh))"
        var dayFiveLow = "\(Int(weather.dayFiveLow))"
        var daySixHigh = "\(Int(weather.daySixHigh))"
        var daySixLow = "\(Int(weather.daySixLow))"
        var daySevenHigh = "\(Int(weather.daySevenHigh))"
        var daySevenLow = "\(Int(weather.daySevenLow))"
        
        // initializing 24 hour forecast time params
        let hourZero = "\(timeFormatter.string(from: hourZeroUnix as Date))"
        let hourOne = "\(timeFormatter.string(from: hourOneUnix as Date))"
        let hourTwo = "\(timeFormatter.string(from: hourTwoUnix as Date))"
        let hourThree = "\(timeFormatter.string(from: hourThreeUnix as Date))"
        let hourFour = "\(timeFormatter.string(from: hourFourUnix as Date))"
        let hourFive = "\(timeFormatter.string(from: hourFiveUnix as Date))"
        let hourSix = "\(timeFormatter.string(from: hourSixUnix as Date))"
        let hourSeven = "\(timeFormatter.string(from: hourSevenUnix as Date))"
        let hourEight = "\(timeFormatter.string(from: hourEightUnix as Date))"
        let hourNine = "\(timeFormatter.string(from: hourNineUnix as Date))"
        let hourTen = "\(timeFormatter.string(from: hourTenUnix as Date))"
        let hourEleven = "\(timeFormatter.string(from: hourElevenUnix as Date))"
        let hourTwelve = "\(timeFormatter.string(from: hourTwelveUnix as Date))"
        let hourThirteen = "\(timeFormatter.string(from: hourThirteenUnix as Date))"
        let hourFourteen = "\(timeFormatter.string(from: hourFourteenUnix as Date))"
        let hourFifteen = "\(timeFormatter.string(from: hourFifteenUnix as Date))"
        let hourSixteen = "\(timeFormatter.string(from: hourSixteenUnix as Date))"
        let hourSeventeen = "\(timeFormatter.string(from: hourSeventeenUnix as Date))"
        let hourEighteen = "\(timeFormatter.string(from: hourEighteenUnix as Date))"
        let hourNineteen = "\(timeFormatter.string(from: hourNineteenUnix as Date))"
        let hourTwenty = "\(timeFormatter.string(from: hourTwentyUnix as Date))"
        let hourTwentyOne = "\(timeFormatter.string(from: hourTwentyOneUnix as Date))"
        let hourTwentyTwo = "\(timeFormatter.string(from: hourTwentyTwoUnix as Date))"
        let hourTwentyThree = "\(timeFormatter.string(from: hourTwentyThreeUnix as Date))"
        let hourTwentyFour = "\(timeFormatter.string(from: hourTwentyFourUnix as Date))"
        
        
        // initializing 24 hour temperature params with JSON
        let hourZeroTemp = "\(Int(weather.hourZeroTemp))°"
        let hourOneTemp = "\(Int(weather.hourOneTemp))°"
        let hourTwoTemp = "\(Int(weather.hourTwoTemp))°"
        let hourThreeTemp = "\(Int(weather.hourThreeTemp))°"
        let hourFourTemp = "\(Int(weather.hourFourTemp))°"
        let hourFiveTemp = "\(Int(weather.hourFiveTemp))°"
        let hourSixTemp = "\(Int(weather.hourSixTemp))°"
        let hourSevenTemp = "\(Int(weather.hourSevenTemp))°"
        let hourEightTemp = "\(Int(weather.hourEightTemp))°"
        let hourNineTemp = "\(Int(weather.hourNineTemp))°"
        let hourTenTemp = "\(Int(weather.hourTenTemp))°"
        let hourElevenTemp = "\(Int(weather.hourElevenTemp))°"
        let hourTwelveTemp = "\(Int(weather.hourTwelveTemp))°"
        let hourThirteenTemp = "\(Int(weather.hourThirteenTemp))°"
        let hourFourteenTemp = "\(Int(weather.hourFourteenTemp))°"
        let hourFifteenTemp = "\(Int(weather.hourFifteenTemp))°"
        let hourSixteenTemp = "\(Int(weather.hourSixteenTemp))°"
        let hourSeventeenTemp = "\(Int(weather.hourSeventeenTemp))°"
        let hourEighteenTemp = "\(Int(weather.hourEighteenTemp))°"
        let hourNineteenTemp = "\(Int(weather.hourNineteenTemp))°"
        let hourTwentyTemp = "\(Int(weather.hourTwentyTemp))°"
        let hourTwentyOneTemp = "\(Int(weather.hourTwentyOneTemp))°"
        let hourTwentyTwoTemp = "\(Int(weather.hourTwentyTwoTemp))°"
        let hourTwentyThreeTemp = "\(Int(weather.hourTwentyThreeTemp))°"
        let hourTwentyFourTemp = "\(Int(weather.hourTwentyFourTemp))°"
        
        
        
        // TODO: possibly refactor using guard statements?
        if weather.hourZero < weather.sunriseZero {
            if weather.sunriseZero == 0 {
                sunriseData.text = "n/a"
            } else {
                let sunriseZero = NSDate(timeIntervalSince1970: (weather.sunriseZero + (weather.offset * 3600)))
                sunriseData.text = "\(moreTimeFormatter.string(from: sunriseZero as Date))"
            }

        } else {
            if weather.sunriseOne == 0 {
                sunriseData.text = "n/a"
            } else {
                let sunriseOne = NSDate(timeIntervalSince1970: (weather.sunriseOne + (weather.offset * 3600)))
                sunriseData.text = "\(moreTimeFormatter.string(from: sunriseOne as Date))"
            }
        }
        
        
        if weather.hourZero < weather.sunsetZero {
            if weather.sunsetZero == 0 {
                sunsetData.text = "n/a"
            } else {
                let sunsetZero = NSDate(timeIntervalSince1970: (weather.sunsetZero + (weather.offset * 3600)))
                sunsetData.text = "\(moreTimeFormatter.string(from: sunsetZero as Date))"
            }
            
        } else {
            if weather.sunsetOne == 0 {
                sunsetData.text = "n/a"
            } else {
                let sunsetOne = NSDate(timeIntervalSince1970: (weather.sunsetOne + (weather.offset * 3600)))
                sunsetData.text = "\(moreTimeFormatter.string(from: sunsetOne as Date))"
            }
        }
        
        
        // alternative facts
        
        let rainChanceData = "\(Int(weather.rainChance*100))%"
        let rainIntensityData = "\(weather.rainIntensity) in/hr"
        
        let humidityData = "\(Int(weather.humidity*100))%"
        let windData = "\(Int(weather.wind)) mph"
        
        let ozoneData = "\(Int(weather.ozone)) DU"
        let pressureData = "\(weather.pressure) mbar"
        
        switch weather.moonPhase {
        case 0...0.04:
            moonPhaseData.text = "New Moon"
        case 0.05...0.19:
            moonPhaseData.text = "Waxing Crescent"
        case 0.2...0.29:
            moonPhaseData.text = "First Quarter Moon"
        case 0.3...0.44:
            moonPhaseData.text = "Waxing Gibbous"
        case 0.45...0.54:
            moonPhaseData.text = "Full Moon"
        case 0.55...0.69:
            moonPhaseData.text = "Waning Gibbous"
        case 0.7...0.79:
            moonPhaseData.text = "Last Quarter Moon"
        case 0.8...0.94:
            moonPhaseData.text = "Waning Crescent"
        case 0.95...1:
            moonPhaseData.text = "New Moon"
        default:
            moonPhaseData.text = "Moooooo 🐮"
        }
        
        let uvIndexData = "\(Int(weather.uvIndex))"
        
        
        
        // initializing icon json strings
        let currentIcon = weather.hourZeroIcon
        let hourZeroIcon = weather.hourZeroIcon
        let hourOneIcon = weather.hourOneIcon
        let hourTwoIcon = weather.hourTwoIcon
        let hourThreeIcon = weather.hourThreeIcon
        let hourFourIcon = weather.hourFourIcon
        let hourFiveIcon = weather.hourFiveIcon
        let hourSixIcon = weather.hourSixIcon
        let hourSevenIcon = weather.hourSevenIcon
        let hourEightIcon = weather.hourEightIcon
        let hourNineIcon = weather.hourNineIcon
        let hourTenIcon = weather.hourTenIcon
        let hourElevenIcon = weather.hourElevenIcon
        let hourTwelveIcon = weather.hourTwelveIcon
        let hourThirteenIcon = weather.hourThirteenIcon
        let hourFourteenIcon = weather.hourFourteenIcon
        let hourFifteenIcon = weather.hourFifteenIcon
        let hourSixteenIcon = weather.hourSixteenIcon
        let hourSeventeenIcon = weather.hourSeventeenIcon
        let hourEighteenIcon = weather.hourEighteenIcon
        let hourNineteenIcon = weather.hourNineteenIcon
        let hourTwentyIcon = weather.hourTwentyIcon
        let hourTwentyOneIcon = weather.hourTwentyOneIcon
        let hourTwentyTwoIcon = weather.hourTwentyTwoIcon
        let hourTwentyThreeIcon = weather.hourTwentyThreeIcon
        let hourTwentyFourIcon = weather.hourTwentyFourIcon
        
        let dayOneIcon = weather.dayOneIcon
        let dayTwoIcon = weather.dayTwoIcon
        let dayThreeIcon = weather.dayThreeIcon
        let dayFourIcon = weather.dayFourIcon
        let dayFiveIcon = weather.dayFiveIcon
        let daySixIcon = weather.daySixIcon
        let daySevenIcon = weather.daySevenIcon
        
        // initializing icon animations
        var currentIconView = SKYIconView()
        var hourZeroIconView = SKYIconView()
        var hourOneIconView = SKYIconView()
        var hourTwoIconView = SKYIconView()
        var hourThreeIconView = SKYIconView()
        var hourFourIconView = SKYIconView()
        var hourFiveIconView = SKYIconView()
        var hourSixIconView = SKYIconView()
        var hourSevenIconView = SKYIconView()
        var hourEightIconView = SKYIconView()
        var hourNineIconView = SKYIconView()
        var hourTenIconView = SKYIconView()
        var hourElevenIconView = SKYIconView()
        var hourTwelveIconView = SKYIconView()
        var hourThirteenIconView = SKYIconView()
        var hourFourteenIconView = SKYIconView()
        var hourFifteenIconView = SKYIconView()
        var hourSixteenIconView = SKYIconView()
        var hourSeventeenIconView = SKYIconView()
        var hourEighteenIconView = SKYIconView()
        var hourNineteenIconView = SKYIconView()
        var hourTwentyIconView = SKYIconView()
        var hourTwentyOneIconView = SKYIconView()
        var hourTwentyTwoIconView = SKYIconView()
        var hourTwentyThreeIconView = SKYIconView()
        var hourTwentyFourIconView = SKYIconView()
        
        var dayOneIconView = SKYIconView()
        var dayTwoIconView = SKYIconView()
        var dayThreeIconView = SKYIconView()
        var dayFourIconView = SKYIconView()
        var dayFiveIconView = SKYIconView()
        var daySixIconView = SKYIconView()
        var daySevenIconView = SKYIconView()
        
        // tagging icon views and setting their type(sunny, rainy, cloudy, etc.)
        func setIconAnimation(for iconString: String, iconView: SKYIconView, iconTag: Int) {
            
            iconView.tag = iconTag
            if let viewWithTag = self.view.viewWithTag(iconTag) {
                viewWithTag.removeFromSuperview()
            } else {}

            switch iconString {
            case "clear-day":
                iconView.setType = .clearDay
                iconView.setColor = UIColor.white
            case "clear-night":
                iconView.setType = .clearNight
                iconView.setColor = UIColor.white
            case "rain":
                iconView.setType = .rain
                iconView.setColor = UIColor.white
            case "snow":
                iconView.setType = .snow
                iconView.setColor = UIColor.white
            case "sleet":
                iconView.setType = .sleet
                iconView.setColor = UIColor.white
            case "wind":
                iconView.setType = .wind
                iconView.setColor = UIColor.white
            case "fog":
                iconView.setType = .fog
                iconView.setColor = UIColor.white
            case "cloudy":
                iconView.setType = .cloudy
                iconView.setColor = UIColor(red: 198/255.0, green: 198/255.0, blue: 198/255.0, alpha: 1.0)
            case "partly-cloudy-day":
                iconView.setType = .partlyCloudyDay
                iconView.setColor = UIColor.white
            case "partly-cloudy-night":
                iconView.setType = .partlyCloudyNight
                iconView.setColor = UIColor.white
            default:
                return
            }
        }
        
        // TODO: execute all arguments in a cleaner way. possibly use a struct, or closure??? hmm...
        setIconAnimation(for: currentIcon, iconView: currentIconView, iconTag: 1)
        setIconAnimation(for: hourZeroIcon, iconView: hourZeroIconView, iconTag: 1000)
        setIconAnimation(for: hourOneIcon, iconView: hourOneIconView, iconTag: 1001)
        setIconAnimation(for: hourTwoIcon, iconView: hourTwoIconView, iconTag: 1002)
        setIconAnimation(for: hourThreeIcon, iconView: hourThreeIconView, iconTag: 1003)
        setIconAnimation(for: hourFourIcon, iconView: hourFourIconView, iconTag: 1004)
        setIconAnimation(for: hourFiveIcon, iconView: hourFiveIconView, iconTag: 1005)
        setIconAnimation(for: hourSixIcon, iconView: hourSixIconView, iconTag: 1006)
        setIconAnimation(for: hourSevenIcon, iconView: hourSevenIconView, iconTag: 1007)
        setIconAnimation(for: hourEightIcon, iconView: hourEightIconView, iconTag: 1008)
        setIconAnimation(for: hourNineIcon, iconView: hourNineIconView, iconTag: 1009)
        setIconAnimation(for: hourTenIcon, iconView: hourTenIconView, iconTag: 1010)
        setIconAnimation(for: hourElevenIcon, iconView: hourElevenIconView, iconTag: 1011)
        setIconAnimation(for: hourTwelveIcon, iconView: hourTwelveIconView, iconTag: 1012)
        setIconAnimation(for: hourThirteenIcon, iconView: hourThirteenIconView, iconTag: 1013)
        setIconAnimation(for: hourFourteenIcon, iconView: hourFourteenIconView, iconTag: 1014)
        setIconAnimation(for: hourFifteenIcon, iconView: hourFifteenIconView, iconTag: 1015)
        setIconAnimation(for: hourSixteenIcon, iconView: hourSixteenIconView, iconTag: 1016)
        setIconAnimation(for: hourSeventeenIcon, iconView: hourSeventeenIconView, iconTag: 1017)
        setIconAnimation(for: hourEighteenIcon, iconView: hourEighteenIconView, iconTag: 1018)
        setIconAnimation(for: hourNineteenIcon, iconView: hourNineteenIconView, iconTag: 1019)
        setIconAnimation(for: hourTwentyIcon, iconView: hourTwentyIconView, iconTag: 1020)
        setIconAnimation(for: hourTwentyOneIcon, iconView: hourTwentyOneIconView, iconTag: 1021)
        setIconAnimation(for: hourTwentyTwoIcon, iconView: hourTwentyTwoIconView, iconTag: 1022)
        setIconAnimation(for: hourTwentyThreeIcon, iconView: hourTwentyThreeIconView, iconTag: 1023)
        setIconAnimation(for: hourTwentyFourIcon, iconView: hourTwentyFourIconView, iconTag: 1024)
        
        setIconAnimation(for: dayOneIcon, iconView: dayOneIconView, iconTag: 1101)
        setIconAnimation(for: dayTwoIcon, iconView: dayTwoIconView, iconTag: 1102)
        setIconAnimation(for: dayThreeIcon, iconView: dayThreeIconView, iconTag: 1103)
        setIconAnimation(for: dayFourIcon, iconView: dayFourIconView, iconTag: 1104)
        setIconAnimation(for: dayFiveIcon, iconView: dayFiveIconView, iconTag: 1105)
        setIconAnimation(for: daySixIcon, iconView: daySixIconView, iconTag: 1106)
        setIconAnimation(for: daySevenIcon, iconView: daySevenIconView, iconTag: 1107)
        
        
        
        func addCurrentForecastData() {
            currentIconView.backgroundColor = UIColor.clear
            view.viewWithTag(400)?.addSubview(currentIconView)
            currentIconView.snp.makeConstraints { (make) in
                make.width.height.equalTo(100)
                make.centerX.equalTo(view).dividedBy(1.6)
                make.centerY.equalTo(view.viewWithTag(400)!).offset(15)
            }
            
            dayZeroHighLabel.text = "High: \(Int(weather.dayZeroHigh))"
            dayZeroHighLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
            dayZeroHighLabel.textAlignment = .center
            dayZeroHighLabel.textColor = UIColor.white
            dayZeroHighLabel.tag = 12
            if let dayZeroHighWithTag = self.view.viewWithTag(12) {
                dayZeroHighWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(400)?.addSubview(dayZeroHighLabel)
            dayZeroHighLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(view).multipliedBy(1.375)
                make.centerY.equalTo(currentIconView).offset(15)
            }
            
            dayZeroLowLabel.text = "Low: \(Int(weather.dayZeroLow))"
            dayZeroLowLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 20)
            dayZeroLowLabel.textAlignment = .center
            dayZeroLowLabel.textColor = UIColor.lightText
            dayZeroLowLabel.tag = 11
            if let dayZeroLowWithTag = self.view.viewWithTag(11) {
                dayZeroLowWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(400)?.addSubview(dayZeroLowLabel)
            dayZeroLowLabel.snp.makeConstraints { (make) in
                make.right.equalTo(dayZeroHighLabel)
                make.centerY.equalTo(currentIconView).offset(-15)
            }
            
            hourZeroSummaryLabel.text = "\(weather.hourZeroSummary)"
            hourZeroSummaryLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 35)
            hourZeroSummaryLabel.textAlignment = .center
            hourZeroSummaryLabel.textColor = UIColor.white
            hourZeroSummaryLabel.tag = 13
            if let hourZeroSummaryWithTag = self.view.viewWithTag(13) {
                hourZeroSummaryWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(601)?.addSubview(hourZeroSummaryLabel)
            hourZeroSummaryLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(view)
                make.top.equalTo(view.viewWithTag(601)!).offset(25)
            }
            
            switch Int(weather.hourZeroTemp) {
            case -999 ... -1:
                hourZeroTempLabel.text = "\(Int(weather.hourZeroTemp))°"
                hourZeroTempLabel.font = UIFont(name: "AvenirNext-Medium", size: 140)
            case 0...99:
                hourZeroTempLabel.text = " \(Int(weather.hourZeroTemp))°"
                hourZeroTempLabel.font = UIFont(name: "AvenirNext-Medium", size: 140)
            case 100...999:
                hourZeroTempLabel.text = "\(Int(weather.hourZeroTemp))°"
                hourZeroTempLabel.font = UIFont(name: "AvenirNext-Medium", size: 140)
            default:
                hourZeroTempLabel.text = "n/a"
            }
            
            hourZeroTempLabel.textAlignment = .center
            hourZeroTempLabel.textColor = UIColor.white
            hourZeroTempLabel.tag = 14
            if let hourZeroTempWithTag = self.view.viewWithTag(14) {
                hourZeroTempWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(601)?.addSubview(hourZeroTempLabel)
            hourZeroTempLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(view)
                make.top.equalTo(hourZeroSummaryLabel).offset(20)
            }
        }
        
        addCurrentForecastData()
       
        
        func addHourlyForecastData(for time: String, timeTag: Int, iconView: SKYIconView, spacing: Int, temp: String, tempTag: Int) {
            
            iconView.backgroundColor = UIColor.clear
            self.view.viewWithTag(501)?.addSubview(iconView)
            iconView.snp.makeConstraints { (make) in
                make.width.height.equalTo(32)
                make.centerY.equalTo(view.viewWithTag(501)!)
                make.left.equalTo(spacing)
            }
            
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
            timeLabel.text = time
            timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
            timeLabel.textAlignment = .center
            timeLabel.textColor = UIColor.white
            timeLabel.tag = timeTag
            if let timeLabelWithTag = self.view.viewWithTag(timeTag) {
                timeLabelWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(501)?.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(view.viewWithTag(501)!).dividedBy(3)
                make.centerX.equalTo(iconView)
            }
            
            if timeLabel.tag == 2000 {
                timeLabel.text = "Now"
                timeLabel.font = UIFont(name: "AvenirNext-Bold", size: 15)
            } else {}
            
            let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
            tempLabel.text = temp
            tempLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
            tempLabel.textAlignment = .center
            tempLabel.textColor = UIColor.white
            tempLabel.tag = tempTag
            if let tempLabelWithTag = self.view.viewWithTag(tempTag) {
                tempLabelWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(501)?.addSubview(tempLabel)
            tempLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(view.viewWithTag(501)!).multipliedBy(1.6666666666666666666666)
                make.centerX.equalTo(iconView)
            }
        }
        // TODO: execute all arguments in a cleaner way. possibly use a struct, or closure??? hmm...
        addHourlyForecastData(for: hourZero, timeTag: 2000, iconView: hourZeroIconView, spacing: 16, temp: hourZeroTemp, tempTag: 3000)
        addHourlyForecastData(for: hourOne, timeTag: 2001, iconView: hourOneIconView, spacing: 73, temp: hourOneTemp, tempTag: 3001)
        addHourlyForecastData(for: hourTwo, timeTag: 2002, iconView: hourTwoIconView, spacing: 130, temp: hourTwoTemp, tempTag: 3002)
        addHourlyForecastData(for: hourThree, timeTag: 2003, iconView: hourThreeIconView, spacing: 187, temp: hourThreeTemp, tempTag: 3003)
        addHourlyForecastData(for: hourFour, timeTag: 2004, iconView: hourFourIconView, spacing: 244, temp: hourFourTemp, tempTag: 3004)
        addHourlyForecastData(for: hourFive, timeTag: 2005, iconView: hourFiveIconView, spacing: 301, temp: hourFiveTemp, tempTag: 3005)
        addHourlyForecastData(for: hourSix, timeTag: 2006, iconView: hourSixIconView, spacing: 358, temp: hourSixTemp, tempTag: 3006)
        addHourlyForecastData(for: hourSeven, timeTag: 2007, iconView: hourSevenIconView, spacing: 415, temp: hourSevenTemp, tempTag: 3007)
        addHourlyForecastData(for: hourEight, timeTag: 2008, iconView: hourEightIconView, spacing: 472, temp: hourEightTemp, tempTag: 3008)
        addHourlyForecastData(for: hourNine, timeTag: 2009, iconView: hourNineIconView, spacing: 529, temp: hourNineTemp, tempTag: 3009)
        addHourlyForecastData(for: hourTen, timeTag: 2010, iconView: hourTenIconView, spacing: 586, temp: hourTenTemp, tempTag: 3010)
        addHourlyForecastData(for: hourEleven, timeTag: 2011, iconView: hourElevenIconView, spacing: 643, temp: hourElevenTemp, tempTag: 3011)
        addHourlyForecastData(for: hourTwelve, timeTag: 2012, iconView: hourTwelveIconView, spacing: 700, temp: hourTwelveTemp, tempTag: 3012)
        addHourlyForecastData(for: hourThirteen, timeTag: 2013, iconView: hourThirteenIconView, spacing: 757, temp: hourThirteenTemp, tempTag: 3013)
        addHourlyForecastData(for: hourFourteen, timeTag: 2014, iconView: hourFourteenIconView, spacing: 814, temp: hourFourteenTemp, tempTag: 3014)
        addHourlyForecastData(for: hourFifteen, timeTag: 2015, iconView: hourFifteenIconView, spacing: 871, temp: hourFifteenTemp, tempTag: 3015)
        addHourlyForecastData(for: hourSixteen, timeTag: 2016, iconView: hourSixteenIconView, spacing: 928, temp: hourSixteenTemp, tempTag: 3016)
        addHourlyForecastData(for: hourSeventeen, timeTag: 2017, iconView: hourSeventeenIconView, spacing: 985, temp: hourSeventeenTemp, tempTag: 3017)
        addHourlyForecastData(for: hourEighteen, timeTag: 2018, iconView: hourEighteenIconView, spacing: 1042, temp: hourEighteenTemp, tempTag: 3018)
        addHourlyForecastData(for: hourNineteen, timeTag: 2019, iconView: hourNineteenIconView, spacing: 1099, temp: hourNineteenTemp, tempTag: 3019)
        addHourlyForecastData(for: hourTwenty, timeTag: 2020, iconView: hourTwentyIconView, spacing: 1156, temp: hourTwentyTemp, tempTag: 3020)
        addHourlyForecastData(for: hourTwentyOne, timeTag: 2021, iconView: hourTwentyOneIconView, spacing: 1213, temp: hourTwentyOneTemp, tempTag: 3021)
        addHourlyForecastData(for: hourTwentyTwo, timeTag: 2022, iconView: hourTwentyTwoIconView, spacing: 1270, temp: hourTwentyTwoTemp, tempTag: 3022)
        addHourlyForecastData(for: hourTwentyThree, timeTag: 2023, iconView: hourTwentyThreeIconView, spacing: 1327, temp: hourTwentyThreeTemp, tempTag: 3023)
        addHourlyForecastData(for: hourTwentyFour, timeTag: 2024, iconView: hourTwentyFourIconView, spacing: 1384, temp: hourTwentyFourTemp, tempTag: 3024)
        
        func addDailyForecastData(for day: String, dayTag: Int, iconView: SKYIconView, lowTemp: String, lowTag: Int, highTemp: String, highTag: Int, spacing: Int) {
            dayZeroSummary.text = weather.dayZeroSummary
            dayZeroSummary.textAlignment = .center
            dayZeroSummary.lineBreakMode = .byWordWrapping
            dayZeroSummary.numberOfLines = 0
            dayZeroSummary.sizeToFit()
            dayZeroSummary.font = UIFont(name: "AvenirNext-Medium", size: 15)
            dayZeroSummary.textColor = UIColor.white
            
            iconView.backgroundColor = UIColor.clear
            self.view.viewWithTag(601)?.addSubview(iconView)
            iconView.snp.makeConstraints { (make) in
                make.width.height.equalTo(24)
                make.top.equalTo(dayZeroSummary.snp.bottom).offset(spacing)
                make.centerX.equalTo(view)
            }
            
            let dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 21))
            dayLabel.text = day
            dayLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
            dayLabel.textAlignment = .left
            dayLabel.textColor = UIColor.white
            dayLabel.tag = dayTag
            if let dayLabelWithTag = self.view.viewWithTag(dayTag) {
                dayLabelWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(601)?.addSubview(dayLabel)
            dayLabel.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(16)
                make.centerY.equalTo(iconView)
            }
            
            let dayLowTemp = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 21))
            dayLowTemp.text = lowTemp
            dayLowTemp.font = UIFont(name: "AvenirNext-Medium", size: 15)
            dayLowTemp.textAlignment = .center
            dayLowTemp.textColor = UIColor.lightText
            dayLowTemp.tag = lowTag
            if let dayLowTempWithTag = self.view.viewWithTag(lowTag) {
                dayLowTempWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(601)?.addSubview(dayLowTemp)
            dayLowTemp.snp.makeConstraints { (make) in
                make.right.equalTo(view).offset(-16)
                make.centerY.equalTo(iconView)
            }
            
            let dayHighTemp = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 21))
            dayHighTemp.text = highTemp
            dayHighTemp.font = UIFont(name: "AvenirNext-Medium", size: 15)
            dayHighTemp.textAlignment = .center
            dayHighTemp.textColor = UIColor.white
            dayHighTemp.tag = highTag
            if let dayHighTempWithTag = self.view.viewWithTag(highTag) {
                dayHighTempWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(601)?.addSubview(dayHighTemp)
            dayHighTemp.snp.makeConstraints { (make) in
                make.right.equalTo(view).offset(-48)
                make.centerY.equalTo(iconView)
            }
        }
        
        addDailyForecastData(for: dayOne, dayTag: 21, iconView: dayOneIconView, lowTemp: dayOneLow, lowTag: 31, highTemp: dayOneHigh, highTag: 41, spacing: 35)
        addDailyForecastData(for: dayTwo, dayTag: 22, iconView: dayTwoIconView, lowTemp: dayTwoLow, lowTag: 32, highTemp: dayTwoHigh, highTag: 42, spacing: 65)
        addDailyForecastData(for: dayThree, dayTag: 23, iconView: dayThreeIconView, lowTemp: dayThreeLow, lowTag: 33, highTemp: dayThreeHigh, highTag: 43, spacing: 95)
        addDailyForecastData(for: dayFour, dayTag: 24, iconView: dayFourIconView, lowTemp: dayFourLow, lowTag: 34, highTemp: dayFourHigh, highTag: 44, spacing: 125)
        addDailyForecastData(for: dayFive, dayTag: 25, iconView: dayFiveIconView, lowTemp: dayFiveLow, lowTag: 35, highTemp: dayFiveHigh, highTag: 45, spacing: 155)
        addDailyForecastData(for: daySix, dayTag: 26, iconView: daySixIconView, lowTemp: daySixLow, lowTag: 36, highTemp: daySixHigh, highTag: 46, spacing: 185)
        addDailyForecastData(for: daySeven, dayTag: 27, iconView: daySevenIconView, lowTemp: daySevenLow, lowTag: 37, highTemp: daySevenHigh, highTag: 47, spacing: 215)
        
        
        func addAlternativeFacts(for labelString: String, labelTag: Int, dataString: String, dataTag: Int, spacing: Int) {
            let label = UILabel()
            label.text = labelString
            label.font = UIFont(name: "AvenirNext-Medium", size: 13.5)
            label.textAlignment = .right
            label.textColor = UIColor.white
            label.tag = labelTag
            if let labelWithTag = view.viewWithTag(labelTag) {
                labelWithTag.removeFromSuperview()
            } else {}
            view.viewWithTag(601)?.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalTo(dayZeroSummary.snp.bottom).offset(spacing) //should be 294 for first one
                make.right.equalTo(view.snp.centerX).offset(-8)
            }
            
            let data = UILabel()
            data.text = dataString
            data.font = UIFont(name: "AvenirNext-Medium", size: 13.5)
            data.textAlignment = .left
            data.textColor = UIColor.white
            data.tag = dataTag
            if let dataWithTag = view.viewWithTag(dataTag) {
                dataWithTag.removeFromSuperview()
            } else{}
            view.viewWithTag(601)?.addSubview(data)
            data.snp.makeConstraints { (make) in
                make.top.equalTo(label)
                make.left.equalTo(view.snp.centerX).offset(8)
            }
        }
        
        addAlternativeFacts(for: sunriseLabel, labelTag: 51, dataString: sunriseData.text!, dataTag: 61, spacing: 274)
        addAlternativeFacts(for: sunsetLabel, labelTag: 52, dataString: sunsetData.text!, dataTag: 62, spacing: 289)
        addAlternativeFacts(for: rainChanceLabel, labelTag: 53, dataString: rainChanceData, dataTag: 63, spacing: 319)
        addAlternativeFacts(for: rainIntensityLabel, labelTag: 54, dataString: rainIntensityData, dataTag: 64, spacing: 334)
        addAlternativeFacts(for: humidityLabel, labelTag: 55, dataString: humidityData, dataTag: 65, spacing: 364)
        addAlternativeFacts(for: windLabel, labelTag: 56, dataString: windData, dataTag: 66, spacing: 379)
        addAlternativeFacts(for: ozoneLabel, labelTag: 57, dataString: ozoneData, dataTag: 67, spacing: 409)
        addAlternativeFacts(for: pressureLabel, labelTag: 58, dataString: pressureData, dataTag: 68, spacing: 424)
        addAlternativeFacts(for: moonPhaseLabel, labelTag: 59, dataString: moonPhaseData.text!, dataTag: 69, spacing: 454)
        addAlternativeFacts(for: uvIndexLabel, labelTag: 60, dataString: uvIndexData, dataTag: 70, spacing: 469)
        
        
        
        loadingScreen(text: "Loading...", isHidden: false)
        
    }
    
    func setPlaceholder(_ weather: Placeholder) {
        let textField = searchController?.searchBar.value(forKey: "searchField") as! UITextField
        textField.attributedPlaceholder = NSAttributedString(string: "\(weather.cityName)", attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupHourlyForecastView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor(red: 93/255.0, green: 173/255.0, blue: 226/255.0, alpha: 1.0)
        setupScrollView()
        setupHeaderView()
        
        loadingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = UIColor.white
        loadingLabel.lineBreakMode = .byWordWrapping
        loadingLabel.numberOfLines = 0
        loadingLabel.sizeToFit()
        view.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.center.equalTo(view)
        }
        
        loadingCloud.setType = .cloudy
        loadingCloud.setColor = .white
        loadingCloud.backgroundColor = .clear
        view.addSubview(loadingCloud)
        loadingCloud.snp.makeConstraints { (make) in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        
        loadingScreen(text: "Loading...", isHidden: true)
        
        let infoButton = UIButton()
        let infoButtonIcon = UIImage(named: "infoWhite")
        infoButton.setImage(infoButtonIcon, for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        view.viewWithTag(601)?.addSubview(infoButton)
        infoButton.snp.makeConstraints { (make) in
            make.size.equalTo(30)
            make.left.equalTo(view).offset(16)
            make.bottom.equalTo(view.viewWithTag(601)!).offset(-16)
        }
        
        let curLocButton = UIButton()
        let curLocButtonIcon = UIImage(named: "locationWhite")
        curLocButton.setImage(curLocButtonIcon, for: .normal)
        curLocButton.addTarget(self, action: #selector(curLocPressed), for: .touchUpInside)
        view.viewWithTag(601)?.addSubview(curLocButton)
        curLocButton.snp.makeConstraints { (make) in
            make.size.equalTo(32)
            make.right.equalTo(view).offset(-16)
            make.bottom.equalTo(view.viewWithTag(601)!).offset(-16)
        }

        
        view.viewWithTag(601)?.addSubview(dayZeroSummary)
        dayZeroSummary.snp.makeConstraints { (make) in
            make.width.equalTo(view).offset(-64)
            make.centerX.equalTo(view)
            make.top.equalTo(view.viewWithTag(601)!).offset(481)
        }

 
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                loadingLabel.text = ""
                
            case .authorizedAlways, .authorizedWhenInUse:
                loadingLabel.text = "Loading..."
            }
            
        } else {
            loadingLabel.text = ""
        }

    
        
        
        
        // implementing search bar at top of view that uses google places API
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        resultsViewController?.tableCellBackgroundColor = UIColor(red: 93/255.0, green: 173/255.0, blue: 226/255.0, alpha: 1.0)
        resultsViewController?.primaryTextColor = .white
        resultsViewController?.secondaryTextColor = .white
        resultsViewController?.tableCellSeparatorColor = .white
        resultsViewController?.primaryTextHighlightColor = .lightText
        
        let subView = UIView(frame: CGRect(x: 0, y: 20.0, width: self.view.frame.size.width, height: 44.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.tintColor = UIColor.white
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        // color and font change for search bar stuff
        let textField = searchController?.searchBar.value(forKey: "searchField") as! UITextField
        textField.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = UIColor.lightText
        
        textField.attributedPlaceholder = NSAttributedString(string: "Add City or ZIP Code", attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.textColor = UIColor.white
        
        
        // weather service stuff
        self.weatherService.delegate = self
        
        // current location stuff
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    // what i do with my search result
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        self.weatherService.getWeatherForLocation(place.coordinate)
        
        let textField = searchController?.searchBar.value(forKey: "searchField") as! UITextField
        textField.attributedPlaceholder = NSAttributedString(string: "\(place.name)", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        loadingScreen(text: "Loading...", isHidden: true)


        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // handle error...
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
