//
//  URLProtocolStub.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation

class URLProtocolStub: URLProtocol {
    static var testData: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let data = URLProtocolStub.testData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
}
