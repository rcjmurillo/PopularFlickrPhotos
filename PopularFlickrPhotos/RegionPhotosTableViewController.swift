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
        request.predicate = NSPredicate(format: "region == %@", region)
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
                        managedObjectContext.performBlock {
                            photo.recentOrder = photo.recentOrder.integerValue + 1
                            self.managedObjectContext.save(nil)
                        }
                        photoViewController.photoURL = NSURL(string: photo.imageURL)
                        photoViewController.photoTitle = photo.title
                    }
                }
            }
        }
    }
}
