//
//  CacheManager.swift
//  Weather App
//
//  Created by ptsq2579 on 9/6/25.
//

import Foundation

actor CacheManager<Key: Hashable, Value>{
    private var cache: [Key: (Value, Date)] = [:]
    private let expirationInterval: TimeInterval
    
    init(expirationInterval: TimeInterval = 60) {
        self.expirationInterval = expirationInterval
    }
    
    func getValue(forKey key: Key) -> Value? {
        if let (value, timestamp) = cache[key]{
            if Date().timeIntervalSince(timestamp) < expirationInterval{
                return value
            } else{
                cache.removeValue(forKey: key)
            }
        }
        return nil
    }
    
    func setValue(_ value: Value, for key: Key) {
        cache[key] = (value, Date())
    }
    
    func cleanExpired(){
        let now = Date()
        cache = cache.filter{now.timeIntervalSince($0.value.1)<expirationInterval}
    }
}
