//
//  File.swift
//  Weather App
//
//  Created by ptsq2579 on 4/6/25.
//

import SwiftUI

@MainActor
class CityViewModel: ObservableObject {
    @Published var temp: String = "--"
    @Published var weatherDesc: String = "--"
    @Published var humidity: String = "--"
    @Published var weatherImage: UIImage? = nil
    @Published var isLoading = true
    @Published var weatherAvailable = true
    @Published var errorMessage: String?
    
    private let weatherService : WeatherService
    
    init(weatherService: WeatherService = WeatherAPI()) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(query: String) async throws -> Void {
        defer {
            self.isLoading = false
        }
        do{
            let weatherdata = try await weatherService.searchCity(query: query)
            guard let current = weatherdata.data.currentCondition.first else {
                weatherAvailable = false
                errorMessage = "Weather data missing."
                return
            }
            
            self.temp = current.temp_C
            self.weatherDesc = current.weatherDesc.first?.value ?? "--"
            self.humidity = current.humidity
            
            if let urlString = current.weatherIconUrl.first?.value {
                await loadImage(urlString: urlString)
            }
        }catch{
            weatherAvailable = false
            errorMessage = error.localizedDescription
        }
        
        
    }
    
    private func loadImage(urlString: String) async {
        guard let url = URL(string: urlString)else {return}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.weatherImage = UIImage(data: data)
                    
        } catch {
            print("Image load error: \(error.localizedDescription)")
        }
            
        
    }
    
}
