//
//  File.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
@testable import Weather_App

final class MockNetworkClient : NetworkClientProtocol {
    var dataToReturn: Data?
    var errorToThrow: Error?
    
    func performRequest(url: URL) async throws -> Data {
        if let error = errorToThrow {
            throw error
        }
        
        guard let data = dataToReturn else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
