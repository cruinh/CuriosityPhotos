//
//  Dictionary+JSONTypeParsing.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 9/18/16.
//  Copyright © 2016 Matthew Hayes. All rights reserved.
//

import Foundation

public extension Array where Element : AnyObject {

    public func jsonValues<T: JSONObjectConvertable>() -> [T] {
        var finalArray = [T]()
        for jsonArrayItem in self {
            let jsonItem = JSONType.create(jsonObject: jsonArrayItem)
            switch jsonItem {
            case .invalid(_):
                debugPrint("\(#file):\(#function):\(#line): [--WARNING--]: found item to be invalid as a JSON object")
                continue
            default:
                if let jsonData = T(JSON: jsonItem) {
                    finalArray.append(jsonData)
                } else {
                    debugPrint("\(#file):\(#function):\(#line): [--WARNING--]: failed to parse array item")
                }
            }
        }
        return finalArray
    }
}

//MARK: JSONObjectConvertable support
public extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    public func jsonValue<T: JSONObjectConvertable>(_ key: String) -> T? {
        if let jsonValue = self[key as! Key] as? [String:AnyObject] {
            return T(JSON: .dictionary(dictionary:jsonValue))
        } else if let jsonValue = self[key as! Key] as? [AnyObject] {
            return T(JSON: .array(array:jsonValue))
        } else if let jsonValue = self[key as! Key] as? String {
            return T(JSON: .string(string:jsonValue))
        } else if let jsonValue = self[key as! Key] as? NSNumber {
            return T(JSON: .number(number:jsonValue))
        }
        return nil
    }

    public func jsonValue<T: JSONObjectConvertable>(_ key: String) -> [T] {
        var finalArray = [T]()
        if let jsonArray = self[key as! Key] as? [[String:AnyObject]] {
            for jsonArrayItem in jsonArray {
                let jsonType = JSONType.dictionary(dictionary: jsonArrayItem)
                if let item = T(JSON: jsonType) {
                    finalArray.append(item)
                }
            }
        }
        return finalArray
    }

    public func jsonValue<T: JSONObjectConvertable>(_ key: String) -> [String:T] {
        var finalDictionary = [String: T]()
        if let jsonDictionary = self[key as! Key] as? [String:[String:AnyObject]] {
            for (key, jsonDictionaryItem) in jsonDictionary {
                let jsonType = JSONType.dictionary(dictionary: jsonDictionaryItem)
                if let item = T(JSON: jsonType) {
                    finalDictionary[key] = item
                }
            }
        }
        return finalDictionary
    }

    /**
     looks for a value with the given key
     if the value exists as a String, uses NSDateFormatter and the format "yyyy-MM-dd" to create an NSDate.
     returns nil if the format does not apply to the given string.
     */
    public func jsonValue(_ key: String) -> Date? {
        if let dateInSeconds = self[key as! Key] as? NSNumber {
            return Date(timeIntervalSince1970: TimeInterval(dateInSeconds))
        } else {
            return nil
        }
    }

    /**
     looks for a value with the given key
     if the value exists as a String, it returns the result of NSURL(string:)
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> URL? {
        if let urlString = self[key as! Key] as? String {
            return URL(string: urlString)
        } else {
            return nil
        }
    }

    /**
     looks for a value with the given key
     if the value exists as a String, it returns the result of NSURL(string:)
     returns nil otherwise
     */
    public func jsonValue(_ key: String) -> [URL] {
        var finalArray = [URL]()
        if let urlStringArray = self[key as! Key] as? [String] {
            for urlString in urlStringArray {
                if let url = URL(string: urlString) {
                    finalArray.append(url)
                }
            }
        }
        return finalArray
    }

    public func jsonValue(_ key: String) -> JSONType? {

        if let dictionary = self[key as! Key] as? [String:AnyObject] {
            return JSONType.create(jsonObject: dictionary as AnyObject?)
        } else {
            return nil
        }
    }
}
