//
//  PhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/17/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//
import UIKit

class PhotosTableViewController: UITableViewController {
    
    @lazy var photos: Photo[] = {
        println("Getting photos")
        let d = NSData(contentsOfURL: FlickrFetcher.URLforTopPlaces())
        let data = NSJSONSerialization.JSONObjectWithData(d, options:nil, error:nil) as NSDictionary
        let places = data.valueForKeyPath(FLICKR_RESULTS_PLACES) as NSDictionary[]
        var photos = Photo[]()
        for place in places {
            photos.append(Photo(data: place))
        }
        return photos
    }()
    
    var countries: String[] {
        var countryNames = Array<String>()
        for photo in photos {
            if !contains(countryNames, photo.country) {
                countryNames.append(photo.country)
            }
        }
        return countryNames
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return countries.count
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return photos.filter({ $0.country == self.countries[section] }).count
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return countries[section]
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Place Cell", forIndexPath:indexPath) as UITableViewCell
        let countryName = countries[indexPath.section]
        let photo = photos.filter({ $0.country == countryName})[indexPath.row]
        cell.textLabel.text = photo.region
        cell.detailTextLabel.text = photo.county
        return cell
    }
}
