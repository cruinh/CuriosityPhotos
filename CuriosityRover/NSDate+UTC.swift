//
//  NSDate+UTC.swift
//  uShip
//
//  Created by Matt Hayes on 8/13/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation

//TODO: move this to USFoundation

private var s_utcFormatter: NSDateFormatter?
private var s_utcFormatterSingletonToken: dispatch_once_t = 0 // thanks to https://gist.github.com/kristopherjohnson/7522f92bb5c4b667d506

public extension NSDate
{
    private class func utcFormatter() -> NSDateFormatter
    {
        dispatch_once(&s_utcFormatterSingletonToken, { () -> Void in
            s_utcFormatter = NSDateFormatter()
            s_utcFormatter!.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            s_utcFormatter!.timeZone = NSTimeZone(abbreviation: "GMT")
        })

        return s_utcFormatter!
    }
    
    public class func dateFromUTCFormattedString(utcFormattedString: String) -> NSDate?
    {
        return NSDate.utcFormatter().dateFromString(utcFormattedString)
    }
    
    public func utcString() -> String?
    {
        return NSDate.utcFormatter().stringFromDate(self)
    }
}