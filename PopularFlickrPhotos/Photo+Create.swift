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
            let matches = context.executeFetchRequest(request, error: error)
            
            if !matches || error || matches.count > 1 {
                // Handle the error
            } else if matches.count == 1 {
                photo = matches[0] as Photo
            } else {
                photo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as Photo
                photo.title = photoData[FLICKR_PHOTO_TITLE] as String
                photo.subtitle = photoData.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as String
                photo.unique = photoData[FLICKR_PHOTO_ID] as String
                photo.imageURL = FlickrFetcher.URLforPhoto(photoData, format: FlickrPhotoFormatLarge).absoluteString
                
                let photographerName = photoData.valueForKey(FLICKR_PHOTO_OWNER) as String
                let photographerData = Photographer.createWithName(photographerName, inManagedObjectContext: context)
                photo.photographer = photographerData.photographer
                let regionData = NSData(contentsOfURL: FlickrFetcher.URLforInformationAboutPlace(photoData[FLICKR_PLACE_ID]))
                let regionJSONData = NSJSONSerialization.JSONObjectWithData(regionData, options:nil, error:nil) as NSDictionary
                let regionName = FlickrFetcher.extractRegionNameFromPlaceInformation(regionJSONData)
                photo.region = Region.createWithName(regionName, inManagedObjectContext: context)
                if photographerData.isNew {
                    photo.region.photographerCount = photo.region.photographerCount.integerValue + 1
                }
            }
        }
        return photo
    }
}
