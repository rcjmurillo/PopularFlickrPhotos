//
//  CoreDataHelper.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/6/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

class CoreDataHelper {
    class func fetchManagedObjectContext(completionHandler: (NSManagedObjectContext!) -> Void) {
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        if delegate.managedObjectContext {
            completionHandler(delegate.managedObjectContext)
        }
        let fileManager = NSFileManager.defaultManager()
        let documentDirectory = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        let url = documentDirectory.URLByAppendingPathComponent("FlickrDatabase")
        let document: UIManagedDocument = UIManagedDocument(fileURL: url)
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(url.path)
        let documentReadyHandler: (Bool) -> Void = { (success: Bool) in
            if (success) {
                delegate.managedObjectContext = document.managedObjectContext
                completionHandler(document.managedObjectContext)
            } else {
                println("File could not be opened or created")
            }
        }
        if fileExists {
            document.openWithCompletionHandler(documentReadyHandler)
        } else {
            document.saveToURL(url, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: documentReadyHandler)
        }
    }
    
    class func managedObjectContext() -> NSManagedObjectContext! {
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        return delegate.managedObjectContext
    }
}
