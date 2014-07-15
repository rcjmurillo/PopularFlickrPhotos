//
//  Region.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/13/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import Foundation
import CoreData

class Region: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var photographerCount: NSNumber
    @NSManaged var photos: NSSet

}
