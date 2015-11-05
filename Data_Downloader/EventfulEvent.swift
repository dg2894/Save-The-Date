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

public class EventfulEvent:NSObject, MKAnnotation {
    
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

    
}
