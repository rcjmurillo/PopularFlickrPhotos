//
//  PhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/17/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//
import UIKit

class PhotosTableViewController: UITableViewController {
    
    var data: Dictionary<String, String> {
        get {
            let d = NSData.dataWithContentsOfURL(FlickrFetcher, options: 0, error: nil)
            return NSJSONSerialization.JSONObjectWithData(d)
        }
    }


}
