//
//  CityRepositoryTest.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
import XCTest
@testable import Weather_App

final class CityRepositoryTest: XCTestCase {
    var cityRepository: CityRepository!
    
    override func setUp() {
        super.setUp()
        cityRepository = CityRepository()
        UserDefaults.standard.removeObject(forKey: "Recent Cities")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "Recent Cities")
        super.tearDown()
    }
    
    func testLoadCitiesSucessFromFile(){
        let cities = cityRepository.loadCities()
        XCTAssertFalse(cities.isEmpty, "Expected cities to be loaded from file")
        XCTAssertTrue(cities.contains("Singapore, Singapore"))
        
    }
    
    func testLoadCities_FileMissing_ReturnsEmptyArray() {
        let testBundle = Bundle(for: type(of: self))
        let cities = cityRepository.loadCities(from: testBundle, fileName: "abc")
        XCTAssertTrue(cities.isEmpty, "Expected empty array when file is missing or unreadable")
    }
    
    func testLoadRecentCities(){
        let expectedCities = ["Singapore","Malaysia"]
        UserDefaults.standard.set(expectedCities, forKey: "Recent Cities")
        
        let recentCities = cityRepository.loadRecentCities()
        XCTAssertEqual(recentCities, expectedCities)
    }
    
    func testSaveRecentCitiesInUserDefaults(){
        let citiesToSave = ["New York","London"]
        cityRepository.saveRecentCities(citiesToSave)
        let savedCities = UserDefaults.standard.stringArray(forKey: "Recent Cities")
        XCTAssertEqual(savedCities, citiesToSave)
    }
    
    func testLoadRecentCitiesReturnsEmptyIfNothingSaved(){
        let recent = cityRepository.loadRecentCities()
        XCTAssertEqual(recent, [], "Expected empty array when nothing is saved")
    }
}
