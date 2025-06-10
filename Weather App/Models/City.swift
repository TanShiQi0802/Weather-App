//
//  City.swift
//  Weather App
//
//  Created by ptsq2579 on 3/6/25.
//

import Foundation

struct WeatherResponse: Decodable {
    let data: WeatherData
}

struct WeatherData: Decodable {
    let currentCondition: [CurrentCondition]
    let error: [APIerror]?
    enum CodingKeys: String, CodingKey {
        case currentCondition = "current_condition"
        case error
    }
}

struct CurrentCondition: Decodable {
    let humidity: String
    let weatherDesc: [description]
    let weatherCode: String
    let weatherIconUrl: [url]
    let temp_C: String
}

struct description: Decodable {
    let value: String
}

struct APIerror: Decodable {
    let msg: String
}

struct url: Decodable {
    let value: String
}
