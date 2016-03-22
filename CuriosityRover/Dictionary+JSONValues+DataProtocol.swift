//
//  Dictionary+JSONValues+DataProtocol.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 3/14/16.
//
//

import Foundation

internal extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject
{
    func jsonValue<T: DataProtocol>(key: String) -> T?
    {
        guard let jsonValue = self[key as! Key] as? [String:AnyObject] else { return nil }
        
        return T(JSON: jsonValue)
    }
    
    func jsonValue<T: DataProtocol>(key: String) -> [T]
    {
        var finalArray = [T]()
        if let jsonArray = self[key as! Key] as? [[String:AnyObject]]
        {
            for jsonArrayItem in jsonArray
            {
                if let item = T(JSON: jsonArrayItem)
                {
                    finalArray.append(item)
                }
            }
        }
        return finalArray
    }
    
    func jsonValue<T: DataProtocol>(key: String) -> [String:T]
    {
        var finalDictionary = [String:T]()
        if let jsonDictionary = self[key as! Key] as? [String:[String:AnyObject]]
        {
            for (key, jsonDictionaryItem) in jsonDictionary
            {
                if let item = T(JSON: jsonDictionaryItem)
                {
                    finalDictionary[key] = item
                }
            }
        }
        return finalDictionary
    }
}