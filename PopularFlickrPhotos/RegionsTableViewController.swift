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
    
    func fetchRegions () {
        let fetchRequest = NSFetchRequest(entityName: "Region")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "photographerCount", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let context = document.managedObjectContext
        context.performBlock {
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.debug = true
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchPhotos", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        
        CoreDataHelper.fetchManagedDocument { (document: UIManagedDocument) in
            switch document.documentState {
            case UIDocumentState.Normal:
                self.document = document
                self.fetchRegions()
            default:
                println("Document in state \(document.documentState)")
            }
        }
        

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
                        photosViewController.managedObjectContext = self.document.managedObjectContext
                        photosViewController.region = fetchedResultsController.objectAtIndexPath(indexPath) as Region
                    }
                }
            }
        }
    }
}
