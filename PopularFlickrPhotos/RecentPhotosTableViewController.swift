//
//  RecentPhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/23/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import UIKit

let recentPhotosKey = "Recent Photos"

class RecentPhotosTableViewController: CoreDataTableViewController {
    var document: UIManagedDocument!
    func fetchRecentPhotos() {
        let request = NSFetchRequest(entityName: "Photo")
        request.sortDescriptors = [NSSortDescriptor(key: "recentOrder", ascending: false)]
        request.predicate = NSPredicate(format: "recentOrder > 0")
        request.fetchLimit = 20
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: document.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        println("fetchedResultsController set")
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        CoreDataHelper.fetchManagedDocument { (document: UIManagedDocument) in
            switch document.documentState {
            case UIDocumentState.Normal:
                self.document = document
            default:
                println("Document in state \(document.documentState)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if document {
            self.fetchRecentPhotos()
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Recent Photo Cell", forIndexPath: indexPath) as UITableViewCell!
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as Photo
        cell.textLabel.text =  photo.title
        cell.detailTextLabel.text = photo.subtitle
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender is UITableViewCell {
            let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell) as NSIndexPath
            if segue.identifier == "Display Recent Photo" {
                if segue.destinationViewController is PhotoViewController {
                    let photoViewController = segue.destinationViewController as PhotoViewController
                    let photo = fetchedResultsController.objectAtIndexPath(indexPath) as Photo
                    photoViewController.photoURL = NSURL(string: photo.imageURL)
                    photoViewController.photoTitle = photo.title
                }
            }
        }
    }
}
