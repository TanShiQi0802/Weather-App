//
//  WeatherAPITest.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
import XCTest
@testable import Weather_App
typealias WeatherDescription = Weather_App.description
typealias WeatherURL = Weather_App.url
final class WeatherAPITest: XCTestCase {
    var mockNetworkClient : MockNetworkClient!
    var cacheManager: CacheManager<String, WeatherResponse>!
    var weatherAPI: WeatherAPI!
    
    override func setUp(){
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        cacheManager = CacheManager()
        weatherAPI = WeatherAPI(networkClient: mockNetworkClient, cacheManager: cacheManager)
    }
    
    func testSearchCityReturnsWeatherResponse() async throws {
        let json = """
               {
                 "data": {
                   "current_condition": [
                     {
                       "humidity": "80",
                       "weatherDesc": [{"value": "Partly cloudy"}],
                       "weatherCode": "116",
                       "weatherIconUrl": [{"value": "http://example.com/icon.png"}],
                       "temp_C": "22"
                     }
                   ]
                 }
               }
               """
        
        mockNetworkClient.dataToReturn = json.data(using: .utf8)
        let response = try await weatherAPI.searchCity(query: "Singapore")

        XCTAssertEqual(response.data.currentCondition.first?.humidity, "80")
        XCTAssertEqual(response.data.currentCondition.first?.weatherDesc.first?.value, "Partly cloudy")
        XCTAssertEqual(response.data.currentCondition.first?.weatherCode, "116")
        XCTAssertEqual(response.data.currentCondition.first?.weatherIconUrl.first?.value, "http://example.com/icon.png")
        XCTAssertEqual(response.data.currentCondition.first?.temp_C, "22")
        
    }
    
    func testSearchCityThrowsWhenAPIErrorReturned() async throws {
        let jsonWithError = """
                {
                  "data": {
                    "error": [
                      {
                        "msg": "Invalid API key"
                      }
                    ],
                    "current_condition": []
                  }
                }
                """
        mockNetworkClient.dataToReturn = jsonWithError.data(using: .utf8)
        
        do{
            _ = try await weatherAPI.searchCity(query: "InvalidCity")
            XCTFail( "Expected error to be thrown")
        }catch{
            
            XCTAssertEqual((error as NSError).domain, "WeatherAPI")
            XCTAssertEqual((error as NSError).userInfo[NSLocalizedDescriptionKey] as? String, "Invalid API key" )
        }
        
    }
    
    func testSearchCityReturnsCachedResponse() async throws {
        let cachedresponse = WeatherResponse(data: WeatherData(currentCondition: [
            CurrentCondition(
                humidity: "50",
                weatherDesc: [WeatherDescription(value: "Sunny")],
                weatherCode: "113",
                weatherIconUrl: [WeatherURL(value: "http://example.com/sunny.png")], temp_C: "30")
        ], error: nil))
        await cacheManager.setValue(cachedresponse, for: "singapore")
        
        mockNetworkClient.dataToReturn = nil
        let response = try await weatherAPI.searchCity(query: "Singapore")
        XCTAssertEqual(response.data.currentCondition.first?.humidity, "50")
        XCTAssertEqual(response.data.currentCondition.first?.weatherDesc.first?.value, "Sunny")
    }
}
