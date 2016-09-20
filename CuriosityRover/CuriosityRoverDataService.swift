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
    func getData(_ completion: @escaping ((_ JSON: [String:AnyObject]?, _ error:ServiceError?) -> Void))
    {
        let options = Options()
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let apiKey = CuriosityRoverDataService.apiKey()
        let URLString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=\(options.dateString)&page=\(options.page)&api_key=\(apiKey)"
        
        print("requesting data from: \(URLString)")
        
        if let URL = URL(string: URLString)
        {
            let task = session.dataTask(with: URL, completionHandler: { (data, URLResponse, error) -> Void in
                
                print("response: \n\tdata:\(data)\n\tURLResponse:\(URLResponse)\n\terror:\(error)")
                
                if let error = error
                {
                    print("[--ERROR--]")
                    completion(nil,.errorInResponse(error: error as NSError))
                }
                else
                {
                    if let data = data,
                        let JSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:AnyObject]
                    {
                        print("[--GOOD RESPONSE--]:")
                        completion(JSON,nil)
                    }
                    else
                    {
                        print("[--BAD RESPONSE--]: NON-JSON")
                        completion(nil,.nonJSONResponseData(data:data))
                    }
                }
            }) 
            task.resume()
        }
        else
        {
            completion(nil,.badURL(string: URLString))
        }
    }
    
    static var _apiKey : String?
    class func apiKey() -> String
    {
        if _apiKey == nil
        {
            if let apiKeyFilePath = Bundle.main.path(forResource: "apikey", ofType: "txt") , FileManager.default.fileExists(atPath: apiKeyFilePath)
            {
                do
                {
                    _apiKey = try NSString(contentsOfFile: apiKeyFilePath, encoding: String.Encoding.utf8.rawValue) as String
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
        var date: Date
        var page: Int
        
        init(date: Date, page: Int)
        {
            self.date = date
            self.page = page
        }
        
        init()
        {
            page = UserDefaults.standard.integer(forKey: "CURIOSITY_PAGE")
            if page < 1 { page = 1 }
            
            if let date = UserDefaults.standard.object(forKey: "CURIOSITY_DATE") as? Date
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
            UserDefaults.standard.set(date, forKey: "CURIOSITY_DATE")
            UserDefaults.standard.set(page, forKey: "CURIOSITY_PAGE")
            UserDefaults.standard.synchronize()
        }
        
        var dateString: String
            {
            get
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.string(from: date)
            }
        }
    }
    
    enum ServiceError : Error
    {
        case badURL(string: String)
        case errorInResponse(error: NSError)
        case nonJSONResponseData(data: Data?)
    }
}

private func yesterDay() -> Date
{
    let today: Date = Date()
    
    let daysToAdd:Int = -1
    
    // Set up date components
    var dateComponents: DateComponents = DateComponents()
    dateComponents.day = daysToAdd
    
    // Create a calendar
    let gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let yesterDayDate: Date = (gregorianCalendar as NSCalendar).date(byAdding: dateComponents, to: today, options:NSCalendar.Options(rawValue: 0))!
    
    return yesterDayDate
}
