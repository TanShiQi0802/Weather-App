//
//  CityRepositoryProtocol.swift
//  Weather App
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation

protocol CityRepositoryProtocol {
    func loadCities(from bundle: Bundle, fileName: String) -> [String]
    func loadRecentCities() -> [String]
    func saveRecentCities(_ cities: [String])
}
