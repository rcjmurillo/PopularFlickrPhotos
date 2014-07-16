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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = region.name
    }
    
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
        cell.imageView.contentMode = UIViewContentMode.ScaleToFill
        cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 20.0, 20.0)
        if !photo.imageData {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                let imageData = NSData(contentsOfURL: NSURL(string: photo.imageURL))
                let image = UIImage(data: imageData)
                dispatch_async(dispatch_get_main_queue()) {
                    if let updateCell = tableView.cellForRowAtIndexPath(indexPath) {
                        updateCell.imageView.contentMode = UIViewContentMode.ScaleToFill
                        updateCell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 20.0, 20.0)
                        updateCell.imageView.image = image
                        updateCell.setNeedsLayout()
                    }
                    self.managedObjectContext.performBlock {
                        photo.imageData = imageData
                    }
                }
            }
        } else {
            cell.imageView.image = UIImage(data: photo.imageData)
        }
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
