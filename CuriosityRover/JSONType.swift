//
//  JSONType.swift
//
//  Created by Matt Hayes on 11/18/15.
//

import Foundation

//MARK: JSONType
public enum JSONType {
    case array(array:[AnyObject])
    case dictionary(dictionary:[String:AnyObject])
    case string(string: String)
    case number(number: NSNumber)
    case invalid(jsonObject:Any?)
    
    public func rawObject<T>() -> T? {
        switch self {
        case .array(let array):
            return array as? T
        case .dictionary(let dictionary):
            return dictionary as? T
        case .string(let string):
            return string as? T
        case .number(let number):
            return number as? T
        case .invalid(let object):
            return object as? T
        }
    }
    
    public static func create(jsonObject: Any?) -> JSONType {
        if let array = jsonObject as? [AnyObject] {
            return JSONType.array(array: array)
        }
        else if let dictionary = jsonObject as? [String:AnyObject] {
            return JSONType.dictionary(dictionary: dictionary)
        }
        else if let string = jsonObject as? String {
            return JSONType.string(string: string)
        }
        return .invalid(jsonObject: jsonObject!)
    }
}

extension JSONType {
    
    public func jsonValue<T: JSONObjectConvertable>() -> [T]? {
        
        switch self {
        case .array(let array):
            
            var parsedItems = [T]()
            for item in array {
                
                let item = JSONType.create(jsonObject: item)
                if let parsedItem = T(JSON: item) {
                    parsedItems.append(parsedItem)
                }
                
            }
            return parsedItems
            
        default:
            return nil
        }
        
    }
    
    public func jsonValue(key: String) -> JSONType? {
        switch self {
        case .dictionary(let dictionary):
            return JSONType.create(jsonObject: dictionary.jsonValue(key) as AnyObject?)
        default:
            return nil
        }
    }
    
    public func jsonValue<T>(key: String) -> T? {
        switch self {
        case .dictionary(let dictionary):
            return dictionary.jsonValue(key)
        default:
            return nil
        }
    }
    
    public func jsonValue<T>(index: Int) -> T? {
        switch self {
        case .array(let array):
            if let arrayValue = array[index] as? T {
                return arrayValue
            }
        default:
            break
        }
        return nil
    }
    
    public func jsonValue() -> String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    public func jsonValue() -> NSNumber? {
        switch self {
        case .number(let number):
            return number
        default:
            return nil
        }
    }
}
