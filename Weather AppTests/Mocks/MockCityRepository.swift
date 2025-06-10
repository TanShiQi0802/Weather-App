//
//  MockCityRepository.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
@testable import Weather_App
class MockCityRepository: CityRepositoryProtocol {
    var citiesToReturn : [String] = []
    var recentCitiesToReturn : [String] = []
    
    private(set) var savedRecentCities : [String]?
    
    func loadCities(from bundle: Bundle, fileName: String) -> [String] {
        return citiesToReturn
    }
    
    func loadRecentCities() -> [String] {
        return recentCitiesToReturn
    }
    
    func saveRecentCities(_ cities: [String]) {
        savedRecentCities = cities
    }
}
