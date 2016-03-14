//
//  Dictionary+JSONValues.swift
//  uShip
//
//  Created by Matt Hayes on 11/18/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import Foundation

//MARK: generic value types
public extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject
{
    /**
     looks for a value with the given key
     if the value exists with the expected type, returns the value as that type
     returns nil otherwise
     */
    public func jsonValue<T>(key: String) -> T?
    {
        return (self[key as! Key] as? T)
    }
    
    /**
     looks for a value with the given key.
     if the value exists as an array of the expected type, it returns value.
     otherwise returns an empty array of the expected type.
     */
    public func jsonValue<T>(key: String) -> [T]
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
    public func jsonValue(key: String) -> Float?
    {
        return self[key as! Key] as? Float
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Double
     returns nil otherwise
     */
    public func jsonValue(key: String) -> Double?
    {
        return self[key as! Key] as? Double
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt32
     returns nil otherwise
     */
    public func jsonValue(key: String) -> UInt32?
    {
        return self[key as! Key] as? UInt32
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt
     returns nil otherwise
     */
    public func jsonValue(key: String) -> UInt?
    {
        return self[key as! Key] as? UInt
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int64
     returns nil otherwise
     */
    public func jsonValue(key: String) -> Int64?
    {
        return self[key as! Key] as? Int64
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int32
     returns nil otherwise
     */
    public func jsonValue(key: String) -> Int32?
    {
        return self[key as! Key] as? Int32
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int
     returns nil otherwise
     */
    public func jsonValue(key: String) -> Int?
    {
        return self[key as! Key] as? Int
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Float
     returns 0 otherwise
     */
    public func jsonValue(key: String, defaultValue : Float = 0.0) -> Float
    {
        return self[key as! Key] as? Float ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Double
     returns 0 otherwise
     */
    public func jsonValue(key: String, defaultValue : Double = 0.0) -> Double
    {
        return self[key as! Key] as? Double ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt32
     returns 0 otherwise
     */
    public func jsonValue(key: String, defaultValue : UInt32 = 0) -> UInt32
    {
        return self[key as! Key] as? UInt32 ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a UInt
     returns 0 otherwise
     */
    public func jsonValue(key: String, defaultValue : UInt = 0) -> UInt
    {
        return self[key as! Key] as? UInt ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int32
     returns 0 otherwise
     */
    public func jsonValue(key: String, defaultValue : Int64 = 0) -> Int64
    {
        return self[key as! Key] as? Int64 ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int32
     returns 0 otherwise
     */
    public func jsonValue(key: String, defaultValue : Int32 = 0) -> Int32
    {
        return self[key as! Key] as? Int32 ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as an NSNumber, returns the value as a Int
     returns 0 otherwise
     */
    public func jsonValue(key: String, defaultValue : Int = 0) -> Int
    {
        return self[key as! Key] as? Int ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     if the value exists as a String, returns the value
     returns an empty string otherwise
     */
    public func jsonValue(key: String, defaultValue: String = "") -> String
    {
        return self[key as! Key] as? String ?? defaultValue
    }
    
    /**
     looks for a value with the given key
     returns true if the value is an NSNumber that evaluates to true
     returns false if the value does not exist, is the wrong type, or evaluates false
    */
    public func jsonValue(key: String, defaultValue: Bool = false) -> Bool
    {
        return self[key as! Key] as? Bool ?? defaultValue
    }
    
}

//MARK: Foundation value types
public extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject
{
    /**
     looks for a value with the given key
     if the value exists as a String, it calls the extension method NSDate.dateFromUTCFormattedString and returns the result
     returns nil otherwise
     */
    public func jsonValue(key: String) -> NSDate?
    {
        if let dateString = self[key as! Key] as? String
        {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.dateFromString(dateString)
        }
        else
        {
            return nil
        }
    }
    
    /**
     looks for a value with the given key
     if the value exists as a String, it returns the result of NSURL(string:)
     returns nil otherwise
     */
    public func jsonValue(key: String) -> NSURL?
    {
        if let urlString = self[key as! Key] as? String
        {
            return NSURL(string: urlString)
        }
        else
        {
            return nil
        }
    }
    
    /**
     looks for a value with the given key
     if the value exists as a String, it returns the result of NSURL(string:)
     returns nil otherwise
     */
    public func jsonValue(key: String) -> [NSURL]
    {
        var finalArray = [NSURL]()
        if let urlStringArray = self[key as! Key] as? [String]
        {
            for urlString in urlStringArray
            {
                if let url = NSURL(string: urlString)
                {
                    finalArray.append(url)
                }
                else
                {
//TODO: couldn't get this working.  Will come back to it if necessary, we're not actually using it yet
//                    let warning : USDTOWarningSystem.Warning = .OneItemInACollectionOfElementsCouldNotBeParsed(sender: self, json: nil, key: key)
//                    USDTOWarningSystem.sharedInstance.postWarning(warning)
                }
            }
        }
        return finalArray
    }
}