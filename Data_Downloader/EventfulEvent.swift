//
//  EventfulEvent.swift
//  Data_Downloader
//
//  Created by Danielle Gray on 10/21/15.
//  Copyright © 2015 DanielleGray. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

public class EventfulEvent:NSObject, MKAnnotation, NSCoding {
    
    private var theTitle:String
    private var theDate:String
    private var theUrl:String
    private var theDesc: String
    private var isFaved:Bool
    public var coordinate:CLLocationCoordinate2D
    
    init(theTitle:String, theDate:String, theUrl:String, theDesc:String, latitude:Float, longitude:Float, isFaved:Bool){
        self.theTitle = theTitle
        self.theDate = theDate
        self.theUrl = theUrl
        self.theDesc = theDesc
        self.isFaved = isFaved
        coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        
        super.init()
    }
    
    public var title:String?{
        return theTitle
    }
    
    public var date:String?{
        return theDate
    }
    
    public var url:String?{
        return theUrl
    }
    
    public var desc:String?{
        return theDesc
    }
    
    public var faved:Bool?{
        get {
            return isFaved
        }
        set (newVal) {
            isFaved = newVal!
        }
    }
    
    // MARK: NSCoding

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(theTitle, forKey: "title")
        aCoder.encodeObject(theDate, forKey: "date")
        aCoder.encodeObject(theUrl, forKey: "url")
        aCoder.encodeObject(theDesc, forKey: "desc")
        aCoder.encodeBool(isFaved, forKey: "faved")
        aCoder.encodeDouble(coordinate.latitude, forKey: "latitude")
        aCoder.encodeDouble(coordinate.longitude, forKey: "longitude")
    }
    
    required public init(coder aDecoder:NSCoder){
        theTitle = aDecoder.decodeObjectForKey("title") as! String
        theDate = aDecoder.decodeObjectForKey("date") as! String
        theUrl = aDecoder.decodeObjectForKey("url") as! String
        theDesc = aDecoder.decodeObjectForKey("desc") as! String
        isFaved = aDecoder.decodeBoolForKey("faved")
        let latitude = aDecoder.decodeDoubleForKey("latitude")
        let longitude = aDecoder.decodeDoubleForKey("longitude")
        coordinate = CLLocationCoordinate2DMake(
        CLLocationDegrees (latitude),
        CLLocationDegrees (longitude))
        super.init()
    }
    
}
