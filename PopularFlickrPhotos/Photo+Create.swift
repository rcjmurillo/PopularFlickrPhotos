//
//  Photo+Create.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/8/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import UIKit

extension Photo {
    class func createFromFlickrData(photoData: NSDictionary, inManagedObjectContext context:NSManagedObjectContext) -> Photo! {
        var photo: Photo!
        var request = NSFetchRequest(entityName: "Photo")
        let unique = photoData[FLICKR_PHOTO_ID] as String
        request.predicate = NSPredicate(format: "unique = %@", unique)
        
        context.performBlock {
            var error: NSErrorPointer!
            let photos = context.executeFetchRequest(request, error: error) as Photo[]!
            
            if !photos || error || photos.count > 1 {
                // Handle the error
            } else if photos.count == 1 {
                photo = photos[0]
            } else {
                photo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as Photo
                photo.title = photoData[FLICKR_PHOTO_TITLE] as String
                photo.subtitle = photoData.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as String
                photo.unique = photoData[FLICKR_PHOTO_ID] as String
                photo.imageURL = FlickrFetcher.URLforPhoto(photoData, format: FlickrPhotoFormatLarge).absoluteString
                
                let photographerName = photoData.valueForKey(FLICKR_PHOTO_OWNER) as String
                photo.photographer = Photographer.createWithName(photographerName, inManagedObjectContext: context)
                
                let regionData = NSData(contentsOfURL: FlickrFetcher.URLforInformationAboutPlace(photoData[FLICKR_PLACE_ID]))
                let regionJSONData = NSJSONSerialization.JSONObjectWithData(regionData, options:nil, error:nil) as NSDictionary
                let regionName = FlickrFetcher.extractRegionNameFromPlaceInformation(regionJSONData)
                photo.region = Region.createWithName(regionName, inManagedObjectContext: context)
            }
        }
        return photo
    }
}
