//
//  Region+Create.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/9/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

extension Region {
    class func createWithName(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Region! {
        var region: Region!
        var request = NSFetchRequest(entityName: "Region")
        request.predicate = NSPredicate(format: "name = %@", name)
        
        var error: NSErrorPointer!
        let matches = context.executeFetchRequest(request, error: error)
        
        if !matches || error || matches.count > 1 {
            // Handle the error
        } else if matches.count == 1 {
            region = matches[0] as Region
        } else {
            region = NSEntityDescription.insertNewObjectForEntityForName("Region", inManagedObjectContext: context) as Region
            region.name = name
        }
        if region.photographerCount == nil {
            region.photographerCount = 0
        }

        return region
    }
}
