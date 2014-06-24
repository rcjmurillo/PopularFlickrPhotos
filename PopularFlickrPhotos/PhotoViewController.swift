//
//  PhotoViewController.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/23/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    var photoURL: NSURL!
    var photoTitle: String!
    @IBOutlet var scrollView : UIScrollView!
    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photo = UIImage(data: NSData(contentsOfURL: photoURL))
        self.imageView = UIImageView(image: photo)
        
        self.title = photoTitle
        
        self.scrollView.contentSize = photo.size
        self.scrollView.addSubview(self.imageView)
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 0.2
        self.scrollView.maximumZoomScale = 2.0
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.imageView
    }
}
