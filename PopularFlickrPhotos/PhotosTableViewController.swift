//
//  PhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/17/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//
import UIKit

class PhotosTableViewController: CoreDataTableViewController {
    func fetchPlaces() {
        self.refreshControl.beginRefreshing()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let d = NSData(contentsOfURL: FlickrFetcher.URLforRecentGeoreferencedPhotos())
            let data = NSJSONSerialization.JSONObjectWithData(d, options:nil, error:nil) as NSDictionary
            let photos: NSDictionary[] = data.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as NSDictionary[]
            for photo in photos {
                // Fetching the region data from Flickr
                // photographer data: owner, ownername
                let regionData = NSData(contentsOfURL: FlickrFetcher.URLforInformationAboutPlace(photo[FLICKR_PLACE_ID]))
                let regionJSONData = NSJSONSerialization.JSONObjectWithData(regionData, options:nil, error:nil) as NSDictionary
                CoreDataHelper.fetchManagedObjectContext() { (context: NSManagedObjectContext!) in
                    let region = NSEntityDescription.insertNewObjectForEntityForName("Region", inManagedObjectContext: context) as Region
                    region.name = FlickrFetcher.extractRegionNameFromPlaceInformation(regionJSONData)
                    context.save(nil)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func fetchRegions () {
        let fetchRequest = NSFetchRequest(entityName: "Region")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "photographers.count", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        CoreDataHelper.fetchManagedObjectContext { (context: NSManagedObjectContext!) in
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext)
        
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchPlaces", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        fetchRegions()
//        self.fetchPlaces()
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Place Cell", forIndexPath:indexPath) as UITableViewCell!
        let region = fetchedResultsController.objectAtIndexPath(indexPath) as Region
        cell.textLabel.text = region.name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender is UITableViewCell {
            if let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell) {
                if segue.identifier == "Display Photos" {
                    if segue.destinationViewController is PlacePhotosTableViewController {
                        
                    }
                }
            }
        }
    }
}
