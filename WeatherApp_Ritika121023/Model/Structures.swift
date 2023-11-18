//
//  Structures.swift
//  WeatherApp_Ritika121023
//
//  Created by user248634 on 10/14/23.
//

import Foundation

struct WeatherResults:Codable{
    var weather:[Weather]?
    var main: Main
}

struct Main:Codable{
    var temp:Float
}

struct Weather:Codable{
    var icon:String
}
