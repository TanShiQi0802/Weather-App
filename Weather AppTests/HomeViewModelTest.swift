//
//  HomeViewModelTest.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//
import XCTest
import Foundation
@testable import Weather_App
final class HomeViewModelTest : XCTestCase{
    private let repository: CityRepositoryProtocol = MockCityRepository()
    
    func testLoadCities() async throws {
        let mockRepo = MockCityRepository()
        mockRepo.citiesToReturn = ["Singapore", "Seoul", "Sydney"]
        mockRepo.recentCitiesToReturn = ["Seoul", "Sydney"]
                
        let viewModel = HomeViewModel(repository: mockRepo)
        XCTAssertEqual(viewModel.cities, ["Singapore", "Seoul", "Sydney"])
        XCTAssertEqual(viewModel.recentCities, ["Seoul", "Sydney"])
        XCTAssertEqual(viewModel.filteredcities, ["Seoul", "Sydney"])
    }
    
    func testAddRecentCityAddsToFrontAndLimitsTo10() {
           let mockRepo = MockCityRepository()
           mockRepo.recentCitiesToReturn = ["City1", "City2", "City3"]
           
           let viewModel = HomeViewModel(repository: mockRepo)
           
         
           viewModel.addRecentCity(city: "City2")
           XCTAssertEqual(viewModel.recentCities.first, "City2")
           XCTAssertEqual(viewModel.filteredcities.first, "City2")
           
        
           viewModel.addRecentCity(city: "NewCity")
           XCTAssertEqual(viewModel.recentCities.first, "NewCity")
           XCTAssertEqual(viewModel.filteredcities.first, "NewCity")
           
           for i in 4...12 {
               viewModel.addRecentCity(city: "City\(i)")
           }
           XCTAssertLessThanOrEqual(viewModel.recentCities.count, 10)
           XCTAssertEqual(viewModel.filteredcities.count, viewModel.recentCities.count)
           XCTAssertEqual(mockRepo.savedRecentCities, viewModel.recentCities)
       }
       
       func testFilterCitiesEmptyQueryReturnsRecent() {
           let mockRepo = MockCityRepository()
           mockRepo.recentCitiesToReturn = ["Paris", "London"]
           mockRepo.citiesToReturn = ["Paris", "London", "Lisbon"]
           
           let viewModel = HomeViewModel(repository: mockRepo)
           viewModel.filterCities(query: "")
           
           XCTAssertEqual(viewModel.filteredcities, viewModel.recentCities)
       }
       
       func testFilterCitiesWithQueryFiltersCities() {
           let mockRepo = MockCityRepository()
           mockRepo.citiesToReturn = ["Paris", "London", "Lisbon"]
           mockRepo.recentCitiesToReturn = ["Paris", "London"]
           
           let viewModel = HomeViewModel(repository: mockRepo)
           
           viewModel.filterCities(query: "Li")
           XCTAssertEqual(viewModel.filteredcities, ["Lisbon"])
           
           viewModel.filterCities(query: "l")
           XCTAssertEqual(viewModel.filteredcities, ["London", "Lisbon"])
       }
   }

