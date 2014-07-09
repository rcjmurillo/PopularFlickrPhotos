//
//  PlacePhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/21/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//
import UIKit

class RegionPhotosTableViewController: CoreDataTableViewController {
    var region: Region!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhotos()
    }
    
    func fetchPhotos() {
        let request = NSFetchRequest(entityName: "Photo")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Photo Cell", forIndexPath:indexPath) as UITableViewCell!
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as Photo
        cell.textLabel.text = photo.title
        cell.detailTextLabel.text = photo.subtitle
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender is UITableViewCell {
            if let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell) {
                if segue.identifier == "Display Photo" {
                    if segue.destinationViewController is PhotoViewController {
                        let photoViewController = segue.destinationViewController as PhotoViewController
                        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as Photo
                        photoViewController.photoURL = NSURL(string: photo.imageURL)
                        photoViewController.photoTitle = photo.title
                        
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
