//
//  DetailVC.swift
//  Data_Downloader
//
//  Created by Danielle Gray on 11/2/15.
//  Copyright © 2015 DanielleGray. All rights reserved.
//

import UIKit

class DetailVC: UITableViewController {

    let myPlainCell = "PlainCell"
    var bookmark:EventfulEvent?
    var favesVC: FavoritesVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let navVC = self.tabBarController?.viewControllers?[2] as! UINavigationController
        favesVC = navVC.viewControllers[0] as! FavoritesVC

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
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
            cell.textLabel?.font = UIFont.systemFontOfSize(18.0)
            cell.textLabel?.textColor = view.tintColor //clickable blue
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        if indexPath.section == 3 {
            cell.textLabel?.text = "Add to Favorites"
            cell.textLabel?.font = UIFont.systemFontOfSize(18.0)
            cell.textLabel?.textColor = view.tintColor //clickable blue
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        return cell
    }
    
    //MARK: - Table view delegate
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.section == 1{
//            return 100.0
//        }
//        
//        return 44.0
//    }
    
    
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
