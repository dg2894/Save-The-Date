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
    private var favorites:[EventfulEvent]
    static let sharedInstance = EventManager()
    
    private init(){
        events = [EventfulEvent]()
        favorites = [EventfulEvent]()
    }
    
    func getEvents()->[EventfulEvent]{
        return events
    }
    
    
    func getFavorites()->[EventfulEvent]{
        return favorites
    }
    
    func setEvents(argEvents:[EventfulEvent]){
        events = argEvents
    }
    
    func setFavorites(argFavorites:[EventfulEvent]){
        favorites = argFavorites
    }
}
