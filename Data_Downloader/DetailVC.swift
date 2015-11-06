//
//  DetailVC.swift
//  Data_Downloader
//
//  Created by Danielle Gray on 11/2/15.
//  Copyright © 2015 DanielleGray. All rights reserved.
//

import UIKit
import Social

class DetailVC: UITableViewController {

    @IBAction func shareTapped(sender: AnyObject) {
        let string:String = "Check out this cool event!"
        let activityViewController = UIActivityViewController(activityItems: [string, bookmark!.url!], applicationActivities: nil)
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            let popup = UIPopoverController(contentViewController: activityViewController)
            popup.presentPopoverFromBarButtonItem(sender as! UIBarButtonItem, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        } else {
            
            presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    let myPlainCell = "PlainCell"
    var font:UIFont!
    var bookmark:EventfulEvent?
    var favesVC: FavoritesVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let navVC = self.tabBarController?.viewControllers?[2] as! UINavigationController
        favesVC = navVC.viewControllers[0] as! FavoritesVC
        
        font = UIFont(name: "Avenir", size: 18)!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myPlainCell, forIndexPath: indexPath)
        
        //configure the cell
        if indexPath.section == 0{
            cell.textLabel?.text = bookmark?.title
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        }
        
        //configure the cell
        if indexPath.section == 1{
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = bookmark?.desc
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        if indexPath.section == 2 {
            cell.textLabel?.text = "View on web"
            cell.textLabel?.font = font
            cell.textLabel?.textColor = view.tintColor //clickable blue
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        if indexPath.section == 3 {
            cell.textLabel?.text = "Add to Favorites"
            cell.textLabel?.font = font
            cell.textLabel?.textColor = view.tintColor //clickable blue
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        if indexPath.section == 4 {
            cell.textLabel?.text = "Show Event Location on Map"
            cell.textLabel?.font = font
            cell.textLabel?.textColor = view.tintColor //clickable blue
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
            if let url = NSURL(string: (bookmark?.url)!){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        if indexPath.section == 3 && bookmark?.faved == false {
            favesVC.favorites += [bookmark!]
            bookmark?.faved = true
        } else if indexPath.section == 3 && bookmark?.faved == true {
            let alert = UIAlertController(title: "Oops!", message: "You have already favorited this event.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
        
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
