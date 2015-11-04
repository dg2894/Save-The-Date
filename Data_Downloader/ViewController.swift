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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
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
                            
                            //return
                        }
                        
                        if let a1 = d1["event"]{
                            //if a1 is not an array of dictionaries, bail out
                            if !(a1 is [[String:AnyObject]]){
                                print("a1 is not an array of dictionaries - No results found")
                                self.noResults = true
                                
                                //return
                            }
                            
                            for d2 in a1 as! [[String:AnyObject]]{
                                var eventTitle = ""
                                var eventDate = ""
                                var eventURL = ""
                                var eventDesc = ""
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
                                
                                if d2["description"] is NSNull{
                                    eventDesc += "No description"
                                } else if let desc = d2["description"] as! String?{
                                    var str = desc.stringByReplacingOccurrencesOfString("<[^>]+>", withString: " ", options: .RegularExpressionSearch, range: nil)
                                    str = str.stringByReplacingOccurrencesOfString("&#39;", withString: "'", options: .RegularExpressionSearch, range: nil)
                                    eventDesc += str
                                }
                                
                                let latitude = (d2["latitude"] as! NSString).floatValue
                                let longitude = (d2["longitude"] as! NSString).floatValue
                                
                                self.noResults = false
                                
                                let event = EventfulEvent(theTitle: eventTitle, theDate: eventDate, theUrl:eventURL, theDesc: eventDesc, latitude: latitude, longitude: longitude)
                                
                                self.tableData.append(event)
                            }
                        }
                    }
                    
                    
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
            
            searchEvents(trimmed)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
            return cell
        } else {
            cell.textLabel?.text = tableData[indexPath.row].title
            cell.detailTextLabel?.text = "Start time: \(tableData[indexPath.row].date)"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!noResults){
        let detailVC: DetailVC = storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
        let bookmark = tableData[indexPath.row]
        detailVC.bookmark = bookmark
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

