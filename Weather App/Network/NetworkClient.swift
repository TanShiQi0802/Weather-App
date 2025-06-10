//
//  NetworkClient.swift
//  Weather App
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
protocol NetworkClientProtocol {
    func performRequest(url: URL) async throws -> Data
}

final class NetworkClient: NetworkClientProtocol{
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    func performRequest(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
}
