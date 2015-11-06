//
//  EventManager.swift
//  Data Downloader
//
//  Created by jefferson on 10/22/15.
//  Copyright © 2015 tony. All rights reserved.
//

import Foundation

class EventManager {
    private var events:[EventfulEvent]
    static let sharedInstance = EventManager()
    
    private init(){
        events = [EventfulEvent]()
    }
    
    func getEvents()->[EventfulEvent]{
        return events
    }
    
    func setEvents(argEvents:[EventfulEvent]){
        events = argEvents
    }
}
