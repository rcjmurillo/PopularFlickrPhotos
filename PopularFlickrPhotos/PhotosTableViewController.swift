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
        var regionsName = String[]()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let d = NSData(contentsOfURL: FlickrFetcher.URLforRecentGeoreferencedPhotos())
            let data = NSJSONSerialization.JSONObjectWithData(d, options:nil, error:nil) as NSDictionary
            let photos: NSDictionary[] = data.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as NSDictionary[]
            println("Getting \(photos.count) regions")
            println(photos)
            for photo in photos {
                // Fetching the region data from Flickr
                // photographer data: owner, ownername
                let regionData = NSData(contentsOfURL: FlickrFetcher.URLforInformationAboutPlace(photo[FLICKR_PLACE_ID]))
                let regionJSONData = NSJSONSerialization.JSONObjectWithData(regionData, options:nil, error:nil) as NSDictionary
                let regionName = FlickrFetcher.extractRegionNameFromPlaceInformation(regionJSONData)
                println("Getting region \(regionName)")
                regionsName.append(regionName)
            }
            println("Saving regions")
            CoreDataHelper.fetchManagedDocument { (document: UIManagedDocument) in
                for regionName in regionsName {
                    switch document.documentState {
                    case UIDocumentState.Normal:
                        println("Document ready to be used")
                        let context = document.managedObjectContext
                        context.performBlock {
                            let region = NSEntityDescription.insertNewObjectForEntityForName("Region", inManagedObjectContext: context) as Region
                            region.name = regionName
                            println("Region \(region.name) saved")
                        }
                    default:
                        println("Document in state \(document.documentState)")
                    }
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
            NSSortDescriptor(key: "photographers.@count", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        CoreDataHelper.fetchManagedDocument { (document: UIManagedDocument) in
            switch document.documentState {
                case UIDocumentState.Normal:
                    let context = document.managedObjectContext
                    context.performBlock {
                        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                    }
                default:
                    println("Document in state \(document.documentState)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.debug = true
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchPlaces", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        fetchRegions()
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        println("Getting cell")
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
