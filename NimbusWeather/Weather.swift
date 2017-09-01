//
//  Weather.swift
//  Nimbus Weather
//
//  Created by Kyle Truong on 5/29/17.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

struct Weather {
    
    // current forecast
    let hourZeroTemp: Double
    let hourZeroSummary: String
    let hourZeroIcon: String
    let dayZeroSummary: String
    let offset: Double
    let dayZeroLow: Double
    let dayZeroHigh: Double
    
    
    // 24 hour forecast
    let hourZero: Double
    let hourOne: Double
    let hourTwo: Double
    let hourThree: Double
    let hourFour: Double
    let hourFive: Double
    let hourSix: Double
    let hourSeven: Double
    let hourEight: Double
    let hourNine: Double
    let hourTen: Double
    let hourEleven: Double
    let hourTwelve: Double
    let hourThirteen: Double
    let hourFourteen: Double
    let hourFifteen: Double
    let hourSixteen: Double
    let hourSeventeen: Double
    let hourEighteen: Double
    let hourNineteen: Double
    let hourTwenty: Double
    let hourTwentyOne: Double
    let hourTwentyTwo: Double
    let hourTwentyThree: Double
    let hourTwentyFour: Double
    
    let hourOneIcon: String
    let hourTwoIcon: String
    let hourThreeIcon: String
    let hourFourIcon: String
    let hourFiveIcon: String
    let hourSixIcon: String
    let hourSevenIcon: String
    let hourEightIcon: String
    let hourNineIcon: String
    let hourTenIcon: String
    let hourElevenIcon: String
    let hourTwelveIcon: String
    let hourThirteenIcon: String
    let hourFourteenIcon: String
    let hourFifteenIcon: String
    let hourSixteenIcon: String
    let hourSeventeenIcon: String
    let hourEighteenIcon: String
    let hourNineteenIcon: String
    let hourTwentyIcon: String
    let hourTwentyOneIcon: String
    let hourTwentyTwoIcon: String
    let hourTwentyThreeIcon: String
    let hourTwentyFourIcon: String
    
    let hourOneTemp: Double
    let hourTwoTemp: Double
    let hourThreeTemp: Double
    let hourFourTemp: Double
    let hourFiveTemp: Double
    let hourSixTemp: Double
    let hourSevenTemp: Double
    let hourEightTemp: Double
    let hourNineTemp: Double
    let hourTenTemp: Double
    let hourElevenTemp: Double
    let hourTwelveTemp: Double
    let hourThirteenTemp: Double
    let hourFourteenTemp: Double
    let hourFifteenTemp: Double
    let hourSixteenTemp: Double
    let hourSeventeenTemp: Double
    let hourEighteenTemp: Double
    let hourNineteenTemp: Double
    let hourTwentyTemp: Double
    let hourTwentyOneTemp: Double
    let hourTwentyTwoTemp: Double
    let hourTwentyThreeTemp: Double
    let hourTwentyFourTemp: Double
    
    
    // 7 day forecast
    let dayOne: Double
    let dayTwo: Double
    let dayThree: Double
    let dayFour: Double
    let dayFive: Double
    let daySix: Double
    let daySeven: Double
    
    let dayOneHigh: Double
    let dayOneLow: Double
    let dayTwoHigh: Double
    let dayTwoLow: Double
    let dayThreeHigh: Double
    let dayThreeLow: Double
    let dayFourHigh: Double
    let dayFourLow: Double
    let dayFiveHigh: Double
    let dayFiveLow: Double
    let daySixHigh: Double
    let daySixLow: Double
    let daySevenHigh: Double
    let daySevenLow: Double
    
    let dayOneIcon: String
    let dayTwoIcon: String
    let dayThreeIcon: String
    let dayFourIcon: String
    let dayFiveIcon: String
    let daySixIcon: String
    let daySevenIcon: String
    
    
    // alternative fax
    let sunriseZero: Double
    let sunsetZero: Double
    let sunriseOne: Double
    let sunsetOne: Double
    let rainChance: Double
    let rainIntensity: Double
    let humidity: Double
    let wind: Double
    let ozone: Double
    let pressure: Double
    let moonPhase: Double
    let uvIndex: Double
    
    
    init(
        
        // current forecast
        hourZeroTemp: Double,
        hourZeroSummary: String,
        hourZeroIcon: String,
        dayZeroSummary: String,
        offset: Double,
        dayZeroLow: Double,
        dayZeroHigh: Double,
        
        // 24 hour forecast
        hourZero: Double,
        hourOne: Double,
        hourTwo: Double,
        hourThree: Double,
        hourFour: Double,
        hourFive: Double,
        hourSix: Double,
        hourSeven: Double,
        hourEight: Double,
        hourNine: Double,
        hourTen: Double,
        hourEleven: Double,
        hourTwelve: Double,
        hourThirteen: Double,
        hourFourteen: Double,
        hourFifteen: Double,
        hourSixteen: Double,
        hourSeventeen: Double,
        hourEighteen: Double,
        hourNineteen: Double,
        hourTwenty: Double,
        hourTwentyOne: Double,
        hourTwentyTwo: Double,
        hourTwentyThree: Double,
        hourTwentyFour: Double,
        
        hourOneIcon: String,
        hourTwoIcon: String,
        hourThreeIcon: String,
        hourFourIcon: String,
        hourFiveIcon: String,
        hourSixIcon: String,
        hourSevenIcon: String,
        hourEightIcon: String,
        hourNineIcon: String,
        hourTenIcon: String,
        hourElevenIcon: String,
        hourTwelveIcon: String,
        hourThirteenIcon: String,
        hourFourteenIcon: String,
        hourFifteenIcon: String,
        hourSixteenIcon: String,
        hourSeventeenIcon: String,
        hourEighteenIcon: String,
        hourNineteenIcon: String,
        hourTwentyIcon: String,
        hourTwentyOneIcon: String,
        hourTwentyTwoIcon: String,
        hourTwentyThreeIcon: String,
        hourTwentyFourIcon: String,
        
        hourOneTemp: Double,
        hourTwoTemp: Double,
        hourThreeTemp: Double,
        hourFourTemp: Double,
        hourFiveTemp: Double,
        hourSixTemp: Double,
        hourSevenTemp: Double,
        hourEightTemp: Double,
        hourNineTemp: Double,
        hourTenTemp: Double,
        hourElevenTemp: Double,
        hourTwelveTemp: Double,
        hourThirteenTemp: Double,
        hourFourteenTemp: Double,
        hourFifteenTemp: Double,
        hourSixteenTemp: Double,
        hourSeventeenTemp: Double,
        hourEighteenTemp: Double,
        hourNineteenTemp: Double,
        hourTwentyTemp: Double,
        hourTwentyOneTemp: Double,
        hourTwentyTwoTemp: Double,
        hourTwentyThreeTemp: Double,
        hourTwentyFourTemp: Double,



        
        // 7 day forecast
        dayOne: Double,
        dayTwo: Double,
        dayThree: Double,
        dayFour: Double,
        dayFive: Double,
        daySix: Double,
        daySeven: Double,
        
        dayOneHigh: Double,
        dayOneLow: Double,
        dayTwoHigh: Double,
        dayTwoLow: Double,
        dayThreeHigh: Double,
        dayThreeLow: Double,
        dayFourHigh: Double,
        dayFourLow: Double,
        dayFiveHigh: Double,
        dayFiveLow: Double,
        daySixHigh: Double,
        daySixLow: Double,
        daySevenHigh: Double,
        daySevenLow: Double,
        
        dayOneIcon: String,
        dayTwoIcon: String,
        dayThreeIcon: String,
        dayFourIcon: String,
        dayFiveIcon: String,
        daySixIcon: String,
        daySevenIcon: String,
        
        // alternative facts
        sunriseZero: Double,
        sunsetZero: Double,
        sunriseOne: Double,
        sunsetOne: Double,
        rainChance: Double,
        rainIntensity: Double,
        humidity: Double,
        wind: Double,
        ozone: Double,
        pressure: Double,
        moonPhase: Double,
        uvIndex: Double
        
        ) {
        
        
        // initialize
        
        // current forecast
        self.hourZeroTemp = hourZeroTemp
        self.hourZeroSummary = hourZeroSummary
        self.hourZeroIcon = hourZeroIcon
        self.dayZeroSummary = dayZeroSummary
        self.offset = offset
        self.dayZeroLow = dayZeroLow
        self.dayZeroHigh = dayZeroHigh
        
        // 24 hour forecast
        self.hourZero = hourZero
        self.hourOne = hourOne
        self.hourTwo = hourTwo
        self.hourThree = hourThree
        self.hourFour = hourFour
        self.hourFive = hourFive
        self.hourSix = hourSix
        self.hourSeven = hourSeven
        self.hourEight = hourEight
        self.hourNine = hourNine
        self.hourTen = hourTen
        self.hourEleven = hourEleven
        self.hourTwelve = hourTwelve
        self.hourThirteen = hourThirteen
        self.hourFourteen = hourFourteen
        self.hourFifteen = hourFifteen
        self.hourSixteen = hourSixteen
        self.hourSeventeen = hourSeventeen
        self.hourEighteen = hourEighteen
        self.hourNineteen = hourNineteen
        self.hourTwenty = hourTwenty
        self.hourTwentyOne = hourTwentyOne
        self.hourTwentyTwo = hourTwentyTwo
        self.hourTwentyThree = hourTwentyThree
        self.hourTwentyFour = hourTwentyFour
        
        self.hourOneIcon = hourOneIcon
        self.hourTwoIcon = hourTwoIcon
        self.hourThreeIcon = hourThreeIcon
        self.hourFourIcon = hourFourIcon
        self.hourFiveIcon = hourFiveIcon
        self.hourSixIcon = hourSixIcon
        self.hourSevenIcon = hourSevenIcon
        self.hourEightIcon = hourEightIcon
        self.hourNineIcon = hourNineIcon
        self.hourTenIcon = hourTenIcon
        self.hourElevenIcon = hourElevenIcon
        self.hourTwelveIcon = hourTwelveIcon
        self.hourThirteenIcon = hourThirteenIcon
        self.hourFourteenIcon = hourFourteenIcon
        self.hourFifteenIcon = hourFifteenIcon
        self.hourSixteenIcon = hourSixteenIcon
        self.hourSeventeenIcon = hourSeventeenIcon
        self.hourEighteenIcon = hourEighteenIcon
        self.hourNineteenIcon = hourNineteenIcon
        self.hourTwentyIcon = hourTwentyIcon
        self.hourTwentyOneIcon = hourTwentyOneIcon
        self.hourTwentyTwoIcon = hourTwentyTwoIcon
        self.hourTwentyThreeIcon = hourTwentyThreeIcon
        self.hourTwentyFourIcon = hourTwentyFourIcon
        
        self.hourOneTemp = hourOneTemp
        self.hourTwoTemp = hourTwoTemp
        self.hourThreeTemp = hourThreeTemp
        self.hourFourTemp = hourFourTemp
        self.hourFiveTemp = hourFiveTemp
        self.hourSixTemp = hourSixTemp
        self.hourSevenTemp = hourSevenTemp
        self.hourEightTemp = hourEightTemp
        self.hourNineTemp = hourNineTemp
        self.hourTenTemp = hourTenTemp
        self.hourElevenTemp = hourElevenTemp
        self.hourTwelveTemp = hourTwelveTemp
        self.hourThirteenTemp = hourThirteenTemp
        self.hourFourteenTemp = hourFourteenTemp
        self.hourFifteenTemp = hourFifteenTemp
        self.hourSixteenTemp = hourSixteenTemp
        self.hourSeventeenTemp = hourSeventeenTemp
        self.hourEighteenTemp = hourEighteenTemp
        self.hourNineteenTemp = hourNineteenTemp
        self.hourTwentyTemp = hourTwentyTemp
        self.hourTwentyOneTemp = hourTwentyOneTemp
        self.hourTwentyTwoTemp = hourTwentyTwoTemp
        self.hourTwentyThreeTemp = hourTwentyThreeTemp
        self.hourTwentyFourTemp = hourTwentyFourTemp
        
        // 7 day forecast
        self.dayOne = dayOne
        self.dayTwo = dayTwo
        self.dayThree = dayThree
        self.dayFour = dayFour
        self.dayFive = dayFive
        self.daySix = daySix
        self.daySeven = daySeven
        
        self.dayOneHigh = dayOneHigh
        self.dayOneLow = dayOneLow
        self.dayTwoHigh = dayTwoHigh
        self.dayTwoLow = dayTwoLow
        self.dayThreeHigh = dayThreeHigh
        self.dayThreeLow = dayThreeLow
        self.dayFourHigh = dayFourHigh
        self.dayFourLow = dayFourLow
        self.dayFiveHigh = dayFiveHigh
        self.dayFiveLow = dayFiveLow
        self.daySixHigh = daySixHigh
        self.daySixLow = daySixLow
        self.daySevenHigh = daySevenHigh
        self.daySevenLow = daySevenLow
        
        self.dayOneIcon = dayOneIcon
        self.dayTwoIcon = dayTwoIcon
        self.dayThreeIcon = dayThreeIcon
        self.dayFourIcon = dayFourIcon
        self.dayFiveIcon = dayFiveIcon
        self.daySixIcon = daySixIcon
        self.daySevenIcon = daySevenIcon
        
        
        // alternative fax
        self.sunriseZero = sunriseZero
        self.sunsetZero = sunsetZero
        self.sunriseOne = sunriseOne
        self.sunsetOne = sunsetOne
        self.rainChance = rainChance
        self.rainIntensity = rainIntensity
        self.humidity = humidity
        self.wind = wind
        self.ozone = ozone
        self.pressure = pressure
        self.moonPhase = moonPhase
        self.uvIndex = uvIndex
        
        
        
    }
}
