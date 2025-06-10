//
//  NetwrokClientTest.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
import XCTest
@testable import Weather_App

final class NetworkClientTest: XCTestCase {
    var client: NetworkClient!
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        client = NetworkClient(session: session)
        MockURLProtocol.requestHandler = nil
    }
    
    func testPerformRequestSuccess() async throws {
        let expectedData = "Hello, world!".data(using: .utf8)!
        MockURLProtocol.requestHandler = { (request : URLRequest) in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (response, expectedData)
        }
        
        let url = URL(string: "https://example.com")!
        let data = try await client.performRequest(url: url)
        XCTAssertEqual(data, expectedData)
    }
    
    func testPerformRequestFailureBadResponse() async throws {
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 500,
                    httpVersion: nil,
                    headerFields: nil)!
                return (response, Data())
            }

            let url = URL(string: "https://example.com")!

            do {
                _ = try await client.performRequest(url: url)
                XCTFail("Expected error not thrown")
            } catch {
                XCTAssertTrue(error is URLError)
            }
        }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
}
