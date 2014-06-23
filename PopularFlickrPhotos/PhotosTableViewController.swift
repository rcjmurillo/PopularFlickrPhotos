//
//  PhotosTableViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/17/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//
import UIKit

class PhotosTableViewController: UITableViewController {
    var cache = Dictionary<String, AnyObject>()
    var places: Place[]! {
    didSet {
        cache.removeValueForKey("countries")
        self.tableView.reloadData()
    }
    }
    var countries: String[] {
        if let cachedValue: AnyObject = cache["countries"] {
            return cachedValue as String[]
        } else {
            var countryNames = String[]()
            for place in places {
                if !contains(countryNames, place.country) {
                    countryNames.append(place.country)
                }
            }
            cache["countries"] = countryNames as AnyObject
            return countryNames
        }
    }
    
    func fetchPlaces() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.refreshControl.beginRefreshing()
            let d = NSData(contentsOfURL: FlickrFetcher.URLforTopPlaces())
            let data = NSJSONSerialization.JSONObjectWithData(d, options:nil, error:nil) as NSDictionary
            let places = data.valueForKeyPath(FLICKR_RESULTS_PLACES) as NSDictionary[]
            var placeList = Place[]()
            for place in places {
                placeList.append(Place(data: place))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
                self.places = placeList
            }
        }
    }
    
    func placeForIndexPath(indexPath: NSIndexPath) -> Place {
        let countryName = countries[indexPath.section]
        var filteredPlaces = places.filter({ $0.country == countryName})
        filteredPlaces.sort({ $0.region < $1.region })
        return filteredPlaces[indexPath.row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: "fetchPlaces", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        
        self.fetchPlaces()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        if places {
            return countries.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return places.filter({ $0.country == self.countries[section] }).count
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return countries[section]
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Place Cell", forIndexPath:indexPath) as UITableViewCell
        let place = placeForIndexPath(indexPath)
        cell.textLabel.text = place.region
        cell.detailTextLabel.text = place.county
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender is UITableViewCell {
            if let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell) {
                if segue.identifier == "Display Photos" {
                    if segue.destinationViewController is PlacePhotosTableViewController {
                        let placePhotosTableViewController = segue.destinationViewController as PlacePhotosTableViewController
                        placePhotosTableViewController.placeId = self.placeForIndexPath(indexPath).id
                    }
                }
            }
        }
    }
}
