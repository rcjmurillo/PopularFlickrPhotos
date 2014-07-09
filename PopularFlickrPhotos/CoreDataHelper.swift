//
//  CoreDataHelper.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/6/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

class CoreDataHelper {
    class func fetchManagedDocument(completionHandler: (UIManagedDocument) -> Void) {
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        if delegate.document {
            completionHandler(delegate.document)
        }
        let fileManager = NSFileManager.defaultManager()
        let documentDirectory = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        let url = documentDirectory.URLByAppendingPathComponent("FlickrDatabase.md")
        let document: UIManagedDocument = UIManagedDocument(fileURL: url)
        let documentReadyHandler: (Bool) -> Void = { (success: Bool) in
            if (success) {
                delegate.document = document
                completionHandler(document)
            } else {
                println("File could not be opened or created")
            }
        }
        if NSFileManager.defaultManager().fileExistsAtPath(url.path) {
            document.openWithCompletionHandler(documentReadyHandler)
        } else {
            document.saveToURL(url, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: documentReadyHandler)
        }
    }
    
    class func managedDocument() -> UIManagedDocument {
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        return delegate.document
    }
}
