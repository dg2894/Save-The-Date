//
//  FavoritesVC.swift
//  Data_Downloader
//
//  Created by Danielle Gray on 11/5/15.
//  Copyright © 2015 DanielleGray. All rights reserved.
//

import UIKit

class FavoritesVC: UITableViewController {
    
    var favorites:[EventfulEvent] = []
    var noResults:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        noResults = true
        if(favorites.count > 0) {
            noResults = false
        } else {
            noResults = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        if(favorites.count > 0) {
            noResults = false
        } else {
            noResults = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if favorites.count > 0 {
            return favorites.count
        } else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlainCell", forIndexPath: indexPath)
        if (favorites.count == 0) {
            cell.textLabel?.text = "You do not have any favorites yet."
            cell.detailTextLabel?.text = ""
            cell.accessoryType = UITableViewCellAccessoryType.None
            return cell
        } else {
            cell.textLabel?.text = favorites[indexPath.row].title
            cell.detailTextLabel?.text = "Start time: \(favorites[indexPath.row].date)"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!noResults){
            let detailVC: DetailVC = storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
            let bookmark = favorites[indexPath.row]
            detailVC.bookmark = bookmark
            
            
            self.navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

}
