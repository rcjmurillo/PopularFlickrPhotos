//
//  PhotoCell.swift
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/17/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

class PhotoCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: 50, height: imageView.frame.height)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
}
