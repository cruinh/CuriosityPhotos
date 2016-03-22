//
//  CuriosityRoverDataService.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//
//

import Foundation

class CuriosityRoverDataService
{
    func getData(completion: ((JSON: [String:AnyObject]?, error:Error?) -> Void))
    {
        let options = Options()
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let apiKey = CuriosityRoverDataService.apiKey()
        let URLString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=\(options.dateString)&page=\(options.page)&api_key=\(apiKey)"
        
        print("requesting data from: \(URLString)")
        
        if let URL = NSURL(string: URLString)
        {
            let task = session.dataTaskWithURL(URL) { (data, URLResponse, error) -> Void in
                
                print("response: \n\tdata:\(data)\n\tURLResponse:\(URLResponse)\n\terror:\(error)")
                
                if let error = error
                {
                    print("[--ERROR--]")
                    completion(JSON: nil,error: .ErrorInResponse(error: error))
                }
                else
                {
                    if let data = data,
                        JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String:AnyObject]
                    {
                        print("[--GOOD RESPONSE--]:")
                        completion(JSON: JSON,error: nil)
                    }
                    else
                    {
                        print("[--BAD RESPONSE--]: NON-JSON")
                        completion(JSON: nil,error: .NonJSONResponseData(data:data))
                    }
                }
            }
            task.resume()
        }
        else
        {
            completion(JSON: nil,error: .BadURL(string: URLString))
        }
    }
    
    static var _apiKey : String?
    class func apiKey() -> String
    {
        if _apiKey == nil
        {
            if let apiKeyFilePath = NSBundle.mainBundle().pathForResource("apikey", ofType: "txt") where NSFileManager.defaultManager().fileExistsAtPath(apiKeyFilePath)
            {
                do
                {
                    _apiKey = try NSString(contentsOfFile: apiKeyFilePath, encoding: NSUTF8StringEncoding) as String
                }
                catch
                {
                    print("[--ERROR--]: could not read file at path \"\(apiKeyFilePath)\"")
                    abort()
                }
            }
            
            if _apiKey == nil || _apiKey?.characters.count == 0
            {
                print("[--ERROR--]: Please create the file apikey.txt and ensure that it gets included in the build target for the app.  To request an API key from NASA visit: https://api.nasa.gov.")
                abort()
            }
        }
        return _apiKey!
    }
    
    struct Options
    {
        var date: NSDate
        var page: Int
        
        init(date: NSDate, page: Int)
        {
            self.date = date
            self.page = page
        }
        
        init()
        {
            page = NSUserDefaults.standardUserDefaults().integerForKey("CURIOSITY_PAGE")
            if page < 1 { page = 1 }
            
            if let date = NSUserDefaults.standardUserDefaults().objectForKey("CURIOSITY_DATE") as? NSDate
            {
                self.date = date
            }
            else
            {
                self.date = yesterDay()
            }
        }
        
        func save()
        {
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: "CURIOSITY_DATE")
            NSUserDefaults.standardUserDefaults().setInteger(page, forKey: "CURIOSITY_PAGE")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        var dateString: String
            {
            get
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.stringFromDate(date)
            }
        }
    }
    
    enum Error : ErrorType
    {
        case BadURL(string: String)
        case ErrorInResponse(error: NSError)
        case NonJSONResponseData(data: NSData?)
    }
}

private func yesterDay() -> NSDate
{
    let today: NSDate = NSDate()
    
    let daysToAdd:Int = -1
    
    // Set up date components
    let dateComponents: NSDateComponents = NSDateComponents()
    dateComponents.day = daysToAdd
    
    // Create a calendar
    let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    let yesterDayDate: NSDate = gregorianCalendar.dateByAddingComponents(dateComponents, toDate: today, options:NSCalendarOptions(rawValue: 0))!
    
    return yesterDayDate
}