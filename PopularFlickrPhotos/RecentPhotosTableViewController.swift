//
//  RecentPhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/23/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import UIKit

let recentPhotosKey = "Recent Photos"

class RecentPhotosTableViewController: UITableViewController {
    var recentPhotos: NSDictionary[] {
        return NSUserDefaults.standardUserDefaults().arrayForKey(recentPhotosKey) as NSDictionary[]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Recent Photo Cell") as UITableViewCell!
        let photo = recentPhotos[indexPath.row]
        cell.textLabel.text = photo[FLICKR_PHOTO_TITLE] as String
        cell.detailTextLabel.text = photo[FLICKR_PHOTO_DESCRIPTION] as String
        return cell
    }
}
