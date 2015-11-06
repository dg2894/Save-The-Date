//
//  MapVC.swift
//  Data_Downloader
//
//  Created by Kurt Weinstein on 11/5/15.
//  Copyright © 2015 DanielleGray. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var manager:EventManager = EventManager.sharedInstance
    var METERS_PER_MILE:Double = 1609.344
    var index:Int?
    var fromDetail:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var events = manager.getEvents()
        map.addAnnotations(events)
        print(index)
        if !fromDetail {
            if(events.count > 0) {
                let myRegion = MKCoordinateRegionMakeWithDistance(events[0].coordinate, METERS_PER_MILE * 100,METERS_PER_MILE * 100)
                map.setRegion(myRegion, animated: true)
            }
        } else {
            let myRegion = MKCoordinateRegionMakeWithDistance(events[index!].coordinate, METERS_PER_MILE * 100,METERS_PER_MILE * 100)
            map.setRegion(myRegion, animated: true)
            map.selectAnnotation(events[index!], animated: false)
            fromDetail = false
            index = nil
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
