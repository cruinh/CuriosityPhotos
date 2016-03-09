//
//  JSON.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//  Copyright © 2016 uShip. All rights reserved.
//

import Foundation

internal extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject
{
    func jsonValue<T: DataProtocol>(key: String) -> T?
    {
        if let jsonValue = self[key as! Key] as? [String:AnyObject]
        {
            return T(JSON: jsonValue)
        }
        else
        {
            return nil
        }
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

protocol DataProtocol
{
    init?(JSON: [String:AnyObject]?)
}

struct CuriosityRoverData: DataProtocol, CustomStringConvertible
{
    class PhotoInfo: DataProtocol, CustomStringConvertible
    {
        var id: Int64?
        var sol: Int64?
        var camera : CameraInfo?
        var img_src: NSURL?
        var earth_date: NSDate?
        var rover: RoverInfo?
        var imageReady = false
        
        required init?(JSON: [String:AnyObject]?)
        {
            guard let JSON = JSON else { return nil }
            
            id = JSON.jsonValue("id")
            sol = JSON.jsonValue("sol")
            camera = JSON.jsonValue("camera")
            img_src = JSON.jsonValue("img_src")
            earth_date = JSON.jsonValue("earth_date")
            rover = JSON.jsonValue("rover")
        }
        
        var description: String
        {
            return "====\nPhotoInfo\n\tid:\(id)\n\tsol:\(sol)\n\tcamera:\(camera)\n\timg_src:\(img_src)\n\tearth_date:\(earth_date)\n\trover:\(rover)\n====\n"
        }
    }
    
    struct CameraInfo: DataProtocol, CustomStringConvertible
    {
        var id: Int64?
        var name: String?
        var rover_id: Int64?
        var full_name: String?
        
        init?(JSON: [String:AnyObject]?)
        {
            guard let JSON = JSON else { return nil }
            
            id = JSON.jsonValue("id")
            name = JSON.jsonValue("name")
            rover_id = JSON.jsonValue("rover_id")
            full_name = JSON.jsonValue("full_name")
        }
        
        var description: String
        {
            return "====\nCameraInfo\n\tid:\(id)\n\tname:\(name)\n\trover_id:\(rover_id)\n\tfull_name:\(full_name)\n====\n"
        }
    }
    
    struct CameraSummaryInfo: DataProtocol, CustomStringConvertible
    {
        var name: String?
        var full_name: String?
        
        init?(JSON: [String:AnyObject]?)
        {
            guard let JSON = JSON else { return nil }
            
            name = JSON.jsonValue("name")
            full_name = JSON.jsonValue("full_name")
        }
        
        var description: String
        {
            return "====\nCameraSummaryInfo\n\tname:\(name)\n\tfull_name:\(full_name)\n====\n"
        }
    }
    
    struct RoverInfo: DataProtocol, CustomStringConvertible
    {
        var id: Int64?
        var name: String?
        var landing_date: NSDate?
        var max_sol: Int64?
        var max_date: NSDate?
        var total_photos: Int64?
        var cameras = [CameraInfo]()
        
        init?(JSON: [String:AnyObject]?)
        {
            guard let JSON = JSON else { return nil }
            
            id = JSON.jsonValue("id")
            name = JSON.jsonValue("name")
            landing_date = JSON.jsonValue("landing_date")
            max_sol = JSON.jsonValue("max_sol")
            max_date = JSON.jsonValue("max_date")
            total_photos = JSON.jsonValue("total_photos")
            cameras = JSON.jsonValue("cameras")
        }
        
        var description: String
        {
            return "====\nRoverInfo\n\tid:\(id)\n\tname\(name)\n\tlanding_date:\(landing_date)\n]\tmax_sol:\(max_sol)\n\tmax_date:\(max_date)\n\ttotal_photos:\(total_photos)\n\tcameras:\(cameras)\n====\n"
        }
    }
    
    var photos = [PhotoInfo]()
    
    init?(JSON: [String:AnyObject]?)
    {
        guard let JSON = JSON else { return nil }
        
        photos = JSON.jsonValue("photos")
    }
    
    var description: String
    {
        return "====\nRoverInfo\n\tphotos:\(photos)\n====\n"
    }
}