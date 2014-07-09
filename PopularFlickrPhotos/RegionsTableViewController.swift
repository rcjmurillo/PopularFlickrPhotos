//
//  PhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/17/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//
import UIKit

class RegionsTableViewController: CoreDataTableViewController {
    var document: UIManagedDocument!
    
    func fetchPhotos() {
        self.refreshControl.beginRefreshing()
        var regionsName = String[]()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let d = NSData(contentsOfURL: FlickrFetcher.URLforRecentGeoreferencedPhotos())
            let data = NSJSONSerialization.JSONObjectWithData(d, options:nil, error:nil) as NSDictionary
            let photos: NSDictionary[] = data.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as NSDictionary[]
            println("Getting \(photos.count) photos")
            
            CoreDataHelper.fetchManagedDocument { (document: UIManagedDocument) in
                switch document.documentState {
                    case UIDocumentState.Normal:
                        println("Document ready to be used")
                        self.document = document
                        let context = document.managedObjectContext
                        context.performBlock {
                            for photo in photos {
                                Photo.createFromFlickrData(photo, inManagedObjectContext: context)
                            }
                        }
                    default:
                        println("Document in state \(document.documentState)")
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
            NSSortDescriptor(key: "photographerCount", ascending: false),
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
        refresh.addTarget(self, action: "fetchPhotos", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        fetchRegions()
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Region Cell", forIndexPath:indexPath) as UITableViewCell!
        let region = fetchedResultsController.objectAtIndexPath(indexPath) as Region
        cell.textLabel.text = region.name
        cell.detailTextLabel.text = "\(region.photographerCount) photographers"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender is UITableViewCell {
            if let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell) {
                if segue.identifier == "Display Photos" {
                    if segue.destinationViewController is RegionPhotosTableViewController {
                        let photosViewController = segue.destinationViewController as RegionPhotosTableViewController
                        // TODO: Set the place id
                    }
                }
            }
        }
    }
}
