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
    var manager:EventManager = EventManager.sharedInstance
    var VC:ViewController!
    var mapFav:EventfulEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        noResults = true
        if(favorites.count > 0) {
            noResults = false
        } else {
            noResults = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        favorites = manager.getFavorites()
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlainCell", forIndexPath: indexPath)
        cell.textLabel?.text = favorites[indexPath.row].title
        cell.detailTextLabel?.text = "Start time: \(favorites[indexPath.row].date)"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!noResults){
            let detailVC: DetailVC = storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
            let bookmark = favorites[indexPath.row]
            mapFav = favorites[indexPath.row]
            detailVC.bookmarkIndex = indexPath.row
            detailVC.bookmark = bookmark
            self.navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            favorites[indexPath.row].faved = false
            favorites.removeAtIndex(indexPath.row)
            manager.setFavorites(favorites)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let favoriteToMove = favorites.removeAtIndex(fromIndexPath.row)
        favorites.insert(favoriteToMove, atIndex: toIndexPath.row)
    }

}
