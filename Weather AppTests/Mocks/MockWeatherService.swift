//
//  MockWeatherService.swift
//  Weather App
//
//  Created by ptsq2579 on 9/6/25.
//
import Foundation
@testable import Weather_App

class MockWeatherService: WeatherService {
    var shouldFail = false
    var returnEmptyData = false
    
    func searchCity(query: String) async throws -> WeatherResponse {
        if shouldFail{
            throw URLError(.notConnectedToInternet)
        }
        
        if returnEmptyData {
            return WeatherResponse(
                data: WeatherData(
                    currentCondition: [],
                    error: nil
                )
            )
            
        }
        return WeatherResponse(
            data: WeatherData(
                currentCondition: [
                    CurrentCondition(
                        humidity: "70",
                        weatherDesc: [description(value: "Sunny")],
                        weatherCode: "113",
                        weatherIconUrl: [url(value: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/IMG_logo_%282017%29.svg/512px-IMG_logo_%282017%29.svg.png")],
                        temp_C: "25"
                    )
                ],
                error: nil
            )
        )
        
    }
}
