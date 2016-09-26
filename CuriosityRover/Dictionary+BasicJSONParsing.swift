//
//  Dictionary+BasicJSONParsing.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 9/18/16.
//  Copyright © 2016 Matthew Hayes. All rights reserved.
//

import Foundation

//MARK: generic value types
public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any
{
    /**
     looks for a value with the given key
     if the value exists with the expected type, returns the value as that type
     returns nil otherwise
     */
    public func jsonValue<T>(_ key: String) -> T?
    {
        return (self[key as! Key] as? T)
    }
    
    /**
     looks for a value with the given key.
     if the value exists as an array of the expected type, it returns value.
     otherwise returns an empty array of the expected type.
     */
    public func jsonValue<T>(_ key: String) -> [T]
    {
        if let itemArray = self[key as! Key] as? [T]
        {
            return itemArray
        }
        return [T]()
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Float
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> Float?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.floatValue
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Double
     returns nil otherwise.
     
     NOTE: If you actually require a high degree of precision in your doubles, 
     this implementation may not provide accurate values
     */
    @available(*, deprecated: 1.0) public func jsonValue(_ key: String) -> Double?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.doubleValue
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> UInt?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.uintValue
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt32
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> UInt32?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.uint32Value
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt64
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> UInt64?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.uint64Value
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int64
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> Int64?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.int64Value
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int32
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> Int32?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.int32Value
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> Int?
    {
        if let value = self[key as! Key] as? NSNumber{
            return value.intValue
        }
        return nil
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Float
     returns 0 otherwise
     */
    public func jsonValue(_ key: String, defaultValue : Float = 0.0) -> Float
    {
        let floatValue: Float? = jsonValue(key)
        return floatValue ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Double
     returns 0 otherwise
     
     
     NOTE: If you actually require a high degree of precision in your doubles,
     this implementation may not provide accurate values
     */
    @available(*, deprecated: 1.0) public func jsonValue(_ key: String, defaultValue : Double = 0.0) -> Double
    {
        let doubleValue: Double? = jsonValue(key)
        return doubleValue ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt32
     returns 0 otherwise
     */
    public func jsonValue(_ key: String, defaultValue : UInt32 = 0) -> UInt32
    {
        let uint32Value: UInt32? = jsonValue(key)
        return uint32Value ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt64
     returns 0 otherwise
     */
    public func jsonValue(_ key: String, defaultValue : UInt64 = 0) -> UInt64
    {
        let uint64Value: UInt64? = jsonValue(key)
        return uint64Value ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt
     returns 0 otherwise
     */
    public func jsonValue(_ key: String, defaultValue : UInt = 0) -> UInt
    {
        let uintValue: UInt? = jsonValue(key)
        return uintValue ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int32
     returns 0 otherwise
     */
    public func jsonValue(_ key: String, defaultValue : Int64 = 0) -> Int64
    {
        let int64Value: Int64? = jsonValue(key)
        return int64Value ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int32
     returns 0 otherwise
     */
    public func jsonValue(_ key: String, defaultValue : Int32 = 0) -> Int32
    {
        let int32Value: Int32? = jsonValue(key)
        return int32Value ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int
     returns 0 otherwise
     */
    public func jsonValue(_ key: String, defaultValue : Int = 0) -> Int
    {
        let intValue: Int? = jsonValue(key)
        return intValue ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as a String, returns the value
     returns an empty string otherwise
     */
    public func jsonValue(_ key: String, defaultValue: String = "") -> String
    {
        let stringValue: String? = jsonValue(key)
        return stringValue ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as a String, returns the value
     returns an empty string otherwise
     */
    public func jsonValue(_ key: String) -> String?
    {
        return self[key as! Key] as? String
    }
    
    /**
     looks for a value with the given key
     returns true if the value is an NSNumber that evaluates to true
     returns false if the value does not exist, is the wrong type, or evaluates false
     */
    public func jsonValue(_ key: String, defaultValue: Bool = false) -> Bool
    {
        let boolValue: Bool? = jsonValue(key)
        return boolValue ?? defaultValue
    }
    
}
