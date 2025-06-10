//
//  CityRepository.swift
//  Weather App
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
final class CityRepository : CityRepositoryProtocol{
    private let recentCitiesKey = "Recent Cities"
    
    func loadCities(from bundle: Bundle = .main, fileName: String = "cities")->[String]{
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt"),
              let content = try? String(contentsOf:fileURL, encoding: .utf8) else {
            return []
        }
        let cities = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        return cities
    }
    
    func loadRecentCities() -> [String]{
        return UserDefaults.standard.stringArray(forKey: recentCitiesKey) ?? []
    }
    
    func saveRecentCities(_ recentCities: [String]){
        UserDefaults.standard.set(recentCities, forKey: recentCitiesKey)
    }
}
