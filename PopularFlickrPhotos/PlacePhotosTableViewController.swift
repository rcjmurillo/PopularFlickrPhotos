//
//  PlacePhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/21/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//
import UIKit

class PlacePhotosTableViewController: UITableViewController {
    var placeId: AnyObject!
    var photos: NSDictionary[]! {
    didSet {
        self.tableView.reloadData()
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchPhotos", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        
        self.fetchPhotos()
    }
    
    func fetchPhotos() {
        self.refreshControl.beginRefreshing()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let photosUrl = FlickrFetcher.URLforPhotosInPlace(self.placeId, maxResults: 50)
            let data = NSData(contentsOfURL: photosUrl)
            let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            let photos = jsonResults.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as NSDictionary[]
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
                self.photos = photos
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if photos {
            return photos.count as Int
        }
        return 0
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Photo Cell", forIndexPath:indexPath) as UITableViewCell!
        let photo = self.photos[indexPath.row]
        if let photoTitle = photo[FLICKR_PHOTO_TITLE] as? String {
            cell.textLabel.text = photoTitle
            cell.detailTextLabel.text = photo.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as String
        } else {
            if let photoDescription = photo.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as? String {
                cell.textLabel.text = photoDescription
            } else {
                cell.textLabel.text = "Unknown"
            }
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender is UITableViewCell {
            if let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell) {
                if segue.identifier == "Display Photo" {
                    if segue.destinationViewController is PhotoViewController {
                        let photoViewController = segue.destinationViewController as PhotoViewController
                        let photo = photos[indexPath.row]
                        photoViewController.photoURL = FlickrFetcher.URLforPhoto(photo, format: FlickrPhotoFormatLarge)
                        photoViewController.photoTitle = photo[FLICKR_PHOTO_TITLE] as String
                        
                        var mutableRecentPhotos: NSMutableArray
                        if let recentPhotos = NSUserDefaults.standardUserDefaults().arrayForKey(recentPhotosKey) as NSArray! {
                            mutableRecentPhotos = recentPhotos.mutableCopy() as NSMutableArray
                        } else {
                            mutableRecentPhotos = NSMutableArray()
                        }
                        if !mutableRecentPhotos.containsObject(photo) {
                            mutableRecentPhotos.addObject(photo)
                        }
                        // Storing the photo into NSUserDefaults
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(mutableRecentPhotos, forKey: recentPhotosKey)
                        userDefaults.synchronize()
                    }
                }
            }
        }
    }
}
