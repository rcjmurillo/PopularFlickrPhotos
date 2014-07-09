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
        let cell = tableView.dequeueReusableCellWithIdentifier("Recent Photo Cell", forIndexPath: indexPath) as UITableViewCell!
        let photo = recentPhotos[indexPath.row] as NSDictionary
        cell.textLabel.text =  photo[FLICKR_PHOTO_TITLE] as String
        cell.detailTextLabel.text = photo[FLICKR_PHOTO_DESCRIPTION] as String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender is UITableViewCell {
            let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell) as NSIndexPath
            if segue.identifier == "Display Recent Photo" {
                if segue.destinationViewController is PhotoViewController {
                    let photoViewController = segue.destinationViewController as PhotoViewController
                    let photo = self.recentPhotos[indexPath.row]
                    photoViewController.photoURL = FlickrFetcher.URLforPhoto(photo, format:FlickrPhotoFormatLarge)
                    photoViewController.photoTitle = photo[FLICKR_PHOTO_TITLE] as String
                }
            }
        }
    }
}
