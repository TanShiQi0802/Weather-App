//
//  CacheManagerTest.swift
//  Weather AppTests
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation
import XCTest
@testable import Weather_App

final class CacheManagerTest: XCTestCase {
    func testSetAndGet() async {
        let cache = CacheManager<String, Int>(expirationInterval: 60)
        await cache.setValue(42, for: "answer")
        let value = await cache.getValue(forKey: "answer")
        XCTAssertEqual(value, 42)
    }
    
    func testExpriedValueNil() async {
        let cache = CacheManager<String, Int>(expirationInterval: 1)
        await cache.setValue(99, for: "temp")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let value = await cache.getValue(forKey: "temp")
        XCTAssertNil(value)
    }
    
    func testCleanExpriedValues() async {
        let cache = CacheManager<String, Int>(expirationInterval: 1)
                
                await cache.setValue(123, for: "oldValue")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                
                await cache.setValue(456, for: "newValue")
                await cache.cleanExpired()
                
                let oldValue = await cache.getValue(forKey: "oldValue")
                let newValue = await cache.getValue(forKey: "newValue")
                
                XCTAssertNil(oldValue)
                XCTAssertEqual(newValue, 456)
    }
}
