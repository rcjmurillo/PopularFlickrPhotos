//
//  Photographer+Create.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/8/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import UIKit

extension Photographer {
    class func createWithName(name: String, inManagedObjectContext context: NSManagedObjectContext) -> (photographer: Photographer!, isNew: Bool) {
        var photographer: Photographer!
        var isNew = false
        var request = NSFetchRequest(entityName: "Photographer")
        request.predicate = NSPredicate(format: "name = %@", name)
       
        var error: NSErrorPointer!
        let matches = context.executeFetchRequest(request, error: error)
        
        if !matches || error || matches.count > 1 {
            // Handle the error
        } else if matches.count == 1 {
            photographer = matches[0] as Photographer
        } else {
            photographer = NSEntityDescription.insertNewObjectForEntityForName("Photographer", inManagedObjectContext: context) as Photographer
            photographer.name = name
            isNew = true
        }
        return (photographer, isNew)
    }
}
