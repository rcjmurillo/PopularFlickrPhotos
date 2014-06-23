//
//  Place.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/21/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import UIKit

class Place {
    let data: NSDictionary
    var id: String {
        return data[FLICKR_PLACE_ID] as String
    }
    var country: String {
        let c = data[FLICKR_PLACE_NAME].componentsSeparatedByString(",").reverse()[0] as String
        return c.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    var county: String {
        let c = data[FLICKR_PLACE_NAME].componentsSeparatedByString(",")[1] as String
        return c.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    var region: String {
        let r = data[FLICKR_PLACE_NAME].componentsSeparatedByString(",")[0] as String
        return r.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    init(data d: NSDictionary) {
        data = d
    }
}
