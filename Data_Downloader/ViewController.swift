//
//  ViewController.swift
//  Data_Downloader
//
//  Created by Danielle Gray on 10/14/15.
//  Copyright © 2015 DanielleGray. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var tableData:[EventfulEvent] = []
    var noResults = false
    var manager:EventManager = EventManager.sharedInstance
    var FVC:FavoritesVC!

    
    @IBOutlet weak var tableView: UITableView!
    let METERS_PER_MILE:Double = 1609.344
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
        
        let navVC = self.tabBarController?.viewControllers?[2] as! UINavigationController
        FVC = navVC.viewControllers[0] as! FavoritesVC
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveData", name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    //save favorites array
    func saveData(){
        if FVC.favorites.count > 0 {
            manager.setFavorites(FVC.favorites)
            let myData = NSKeyedArchiver.archivedDataWithRootObject(manager.getFavorites())
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(myData, forKey: "faves")
        }
    }
    
    //load favorites array
    func loadData(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let favesData = defaults.objectForKey("faves") as? NSData
        
        if let favesData = favesData {
            let favesArray = NSKeyedUnarchiver.unarchiveObjectWithData(favesData) as? [EventfulEvent]
            
            if let favesArray = favesArray{
                manager.setFavorites(favesArray)
            }
        }
        
    }
    
    func searchEvents(location:String){
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let myEventsURL = "http://api.eventful.com/json/events/search?app_key=6BFr8DV4jBWKTbw3&sort_order=date&location="
        let url = NSURL(string:myEventsURL + location)
        
        let dataTask = session.dataTaskWithURL(url!, completionHandler:{
            (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            print("error = \(error)")
            //do something with the data, if it exists
            
            if let data = data {
                print("response = \(response)")
                //let s = NSString(data: data, encoding: NSUTF8StringEncoding)
                //print("s = \(s)")
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! [String:AnyObject]
                    print("json = \(json)")
                    
                    //all the code in this completion handler is running
                    //on the background thread. don't believe me? here's some code to prove it
                    print("on main thread in callback() = \(NSThread.isMainThread())")
                    
                    //now parse the JSON
                    //does top level "events" key exist?
                    if let d1 = json["events"]{
                      //if d1 is not a dictionary, bail out
                        if !(d1 is [String:AnyObject]){
                            print("d1 is not a dictionary - No results found")
                            self.noResults = true
                            return
                        }
                        
                        if let a1 = d1["event"]{
                            //if a1 is not an array of dictionaries, bail out
                            if !(a1 is [[String:AnyObject]]){
                                print("a1 is not an array of dictionaries - No results found")
                                self.noResults = true
                                return
                            }
                            
                            for d2 in a1 as! [[String:AnyObject]]{
                                var eventTitle = ""
                                var eventDate = ""
                                var eventURL = ""
                                var eventDesc = ""
                                var eventFav = false
                                //is there a title key in the dictionary?
                                if let title = d2["title"] as! String?{
                                    eventTitle += title
                                }
                                
                                if let date = d2["start_time"] as! String?{
                                    eventDate += date
                                }
                                
                                if let url = d2["url"] as! String? {
                                    eventURL += url
                                }
                                
                                if d2["description"] as? String == " " || d2["description"] is NSNull {
                                    eventDesc += "No description"
                                } else if let desc = d2["description"] as! String?{
                                    var str = desc.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                                    str = str.stringByReplacingOccurrencesOfString("&#39;", withString: "'", options: .RegularExpressionSearch, range: nil)
                                    str = str.stringByReplacingOccurrencesOfString("&quot;", withString: "\"", options: .RegularExpressionSearch, range: nil)
                                    eventDesc += str
                                }
                                
                                let latitude = (d2["latitude"] as! NSString).floatValue
                                let longitude = (d2["longitude"] as! NSString).floatValue
                                
                                for e in self.manager.getFavorites(){
                                    if eventTitle == e.title
                                    && eventDate == e.date
                                    && eventURL == e.url
                                    && eventDesc == e.desc {
                                        eventFav = true
                                    }
                                }
                                
                                self.noResults = false
                                
                                let event = EventfulEvent(theTitle: eventTitle, theDate: eventDate, theUrl:eventURL, theDesc: eventDesc, latitude: latitude, longitude: longitude, isFaved: eventFav)
                                
                                self.tableData.append(event)
                            }
                        }
                    }
                    
                    
                    self.manager.setEvents(self.tableData)
                        
                    
                    //all done? call back to main thread
                    dispatch_async(dispatch_get_main_queue(),{
                        //update the UI
                        self.tableView.reloadData()
                        print("on the main thread in dispatch_async = \(NSThread.isMainThread())")
                    })
                } catch {
                    print(error)
                }
            } else {
                print("No data!")
            }
        })
        
        dataTask.resume()

    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //did the user type something in?
        let text = searchBar.text
        if text == nil || text?.characters.count == 0 {
            return
        }
        
        //do URL encoding - add 20% for spaces
        if let searchTerm = text?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()){
            
        let trimmed = searchTerm.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            //empty the table data (here I'm using parallel arrays)
            tableData = [EventfulEvent]()
            
            tableView.reloadData()
            if(isConnectedToNetwork()) {
                searchEvents(trimmed)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            } else {
                let alert = UIAlertController(title: "Uh-Oh!", message: "Please check your network connection and try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (noResults){
            return 1
        } else {
            return tableData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlainCell", forIndexPath: indexPath)
        if (noResults) {
            cell.textLabel?.text = "No Results Found"
            cell.detailTextLabel?.text = ""
            cell.accessoryType = UITableViewCellAccessoryType.None
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            return cell
        } else {
            cell.textLabel?.text = tableData[indexPath.row].title
            cell.detailTextLabel?.text = "Start time: " + tableData[indexPath.row].date!
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!noResults){
        let detailVC: DetailVC = storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
        let bookmark = tableData[indexPath.row]
        detailVC.bookmark = bookmark
        detailVC.bookmarkIndex = indexPath.row
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func isConnectedToNetwork()->Bool{
        
        var Status:Bool!
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        do {
            _ = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }
        } catch {
            Status = false
        }
        
        return Status
    }
    
}

