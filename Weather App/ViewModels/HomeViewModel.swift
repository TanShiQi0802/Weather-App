//
//  HomeViewModel.swift
//  Weather App
//
//  Created by ptsq2579 on 5/6/25.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject{
    @Published var cities: [String] = []
    @Published var filteredcities: [String] = []
    @Published var recentCities: [String] = []
    
    private let repository : CityRepositoryProtocol
    init(repository: CityRepositoryProtocol = CityRepository()){
        self.repository = repository
        self.cities = repository.loadCities(from: Bundle.main, fileName: "cities")
        self.recentCities = repository.loadRecentCities()
        self.filteredcities = recentCities
        
    }
    
    func addRecentCity(city: String){
        if let index = recentCities.firstIndex(of: city) {
            recentCities.remove(at: index)
        }
        recentCities.insert(city, at: 0)
        if recentCities.count > 10 {
            recentCities.removeLast()
        }
        
        repository.saveRecentCities(recentCities)
        filteredcities = recentCities
    }
    
    func filterCities(query: String){
        if query.isEmpty{
            filteredcities = recentCities
        }
        else{
            filteredcities = cities.filter { $0.lowercased().hasPrefix(query.lowercased()) }
        }
    }
    
}
