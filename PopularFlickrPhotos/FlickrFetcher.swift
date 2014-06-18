//
//  FlickrFetcher.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/17/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import Foundation

let FlickrAPIKey = ""
// key paths to photos or places at top-level of Flickr results
let FLICKR_RESULTS_PHOTOS = "photos.photo"
let FLICKR_RESULTS_PLACES = "places.place"

enum FlickrPhotoFormat: Int {
    case FlickrPhotoFormatSquare = 1    // thumbnail
    case FlickrPhotoFormatLarge = 2     // normal size
    case FlickrPhotoFormatOriginal = 64  // high resolution
}

class FlickrFetcher {
    func urlForQuery(var query: String) -> NSURL {
        query = "\(query)&format=json&nojsoncallback=1&api_key=\(FlickrAPIKey)"
        query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return NSURL(string: query);
    }
    
    func urlForTopPlaces() -> NSURL {
        return self.urlForQuery("https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7")
    }
    
    func urlForPhotosInPlace(flickrPlaceId:AnyObject, maxResults:Int) -> NSURL {
        return self.urlForQuery("https://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=\(flickrPlaceId)&per_page=\(maxResults)&extras=original_format,tags,description,geo,date_upload,owner_name,place_url")
    }
    
    func urlForRecentGeoreferencedPhotos() -> NSURL {
        return self.urlForQuery("https://api.flickr.com/services/rest/?method=flickr.photos.search&license=1,2,4,7&has_geo=1&extras=original_format,description,geo,date_upload,owner_name")
    }
    
    func urlStringForPhoto(photo:Dictionary<String, String>, format:FlickrPhotoFormat) -> NSURL {
        let farm = photo["farm"]
        let server = photo["server"]
        let photoId = photo["id"]
        var secret = photo["secret"]
        
        var fileType = "jpg"
        if format == .FlickrPhotoFormatOriginal {
            secret = photo["originalsecret"]
            fileType = photo["originalformat"]
        }
    }
}
