//
//  CityViewModelTest.swift
//  Weather App
//
//  Created by ptsq2579 on 9/6/25.
//

import XCTest
@testable import Weather_App
import UIKit
import SwiftUI

final class CityViewModelTest: XCTestCase {
    func testFetchWeatherSuccess() async throws {
        let mockService = MockWeatherService()
        let viewModel = await CityViewModel(weatherService: mockService)
        
        try await viewModel.fetchWeather(query: "Singapore")
        
        await MainActor.run{
            XCTAssertEqual(viewModel.temp, "25")
            XCTAssertEqual(viewModel.weatherDesc, "Sunny")
            XCTAssertEqual(viewModel.humidity, "70")
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertTrue(viewModel.weatherAvailable)
            XCTAssertNil(viewModel.errorMessage)}
    }
    
    func testFetchWeatherFail() async throws {
        let mockService = MockWeatherService()
        mockService.shouldFail = true
        let viewModel = await CityViewModel(weatherService: mockService)
        
        do {
            try await viewModel.fetchWeather(query: "Singapore")
        } catch {
        }
        
        await MainActor.run{
            XCTAssertFalse(viewModel.weatherAvailable)
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.isLoading)
        }
    }
    
    func testFetchWeatherNoCurrentCondition() async {
            let mockService = MockWeatherService()
            mockService.returnEmptyData = true
            let viewModel = await CityViewModel(weatherService: mockService)

            try? await viewModel.fetchWeather(query: "Singapore")
            
        await MainActor.run{
            XCTAssertFalse(viewModel.weatherAvailable)
            XCTAssertEqual(viewModel.errorMessage, "Weather data missing.")
            XCTAssertFalse(viewModel.isLoading)
        }
           
        }
    
    func testLoadImageSuccess() async throws {
        let mockService = MockWeatherService()
        let viewModel = await CityViewModel(weatherService: mockService)
        
        try await viewModel.fetchWeather(query: "Singapore")
        await MainActor.run{
            XCTAssertNotNil(viewModel.weatherImage)
        }
       
    }
}
