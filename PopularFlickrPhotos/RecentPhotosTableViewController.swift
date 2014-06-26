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
        let photos = NSUserDefaults.standardUserDefaults().arrayForKey(recentPhotosKey)
        if !photos {
            return NSDictionary[]()
        }
        return photos as NSDictionary[]
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return recentPhotos.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let photo = recentPhotos[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Recent Photo Cell", forIndexPath:indexPath) as UITableViewCell!
        let usableCell = cell as UITableViewCell
        usableCell.textLabel.text = photo[FLICKR_PHOTO_TITLE] as String
        usableCell.detailTextLabel.text = photo[FLICKR_PHOTO_DESCRIPTION] as String
        return usableCell
    }
}
