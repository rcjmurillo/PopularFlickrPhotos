//
//  Photo.h
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/5/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) Photographer *photographer;

@end
