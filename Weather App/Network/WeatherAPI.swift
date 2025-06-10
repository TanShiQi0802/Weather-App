//
//  WeatherAPI.swift
//  Weather App
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation

protocol WeatherService{
    func searchCity(query: String) async throws->WeatherResponse
}

final class WeatherAPI : WeatherService{
    private let networkClient : NetworkClientProtocol
    private let cacheManager: CacheManager<String, WeatherResponse>
    
    private let apiKey = "78919cb7336e4e4f90e30727250306"
    private let baseURL: String
    
    init(baseURL: String = "https://api.worldweatheronline.com/premium/v1/weather.ashx",
         networkClient: NetworkClientProtocol = NetworkClient(),
         cacheManager: CacheManager<String, WeatherResponse> = CacheManager()) {
        self.baseURL = baseURL
        self.networkClient = networkClient
        self.cacheManager = cacheManager
    }
    
    func searchCity(query: String) async throws -> WeatherResponse {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if let cachedResponse = await cacheManager.getValue(forKey: normalizedQuery){
            return cachedResponse
        }
        
        guard var components = URLComponents(string: baseURL) else{
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: normalizedQuery),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "num_of_days", value: "1"),
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let data = try await networkClient.performRequest(url: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: data)
        if let error = response.data.error?.first{
            throw NSError(domain: "WeatherAPI", code: 1001, userInfo: [NSLocalizedDescriptionKey: error.msg])
        }
        
        await cacheManager.setValue(response, for: normalizedQuery)
        return response
    }
}
