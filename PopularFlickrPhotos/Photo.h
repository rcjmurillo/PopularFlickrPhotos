//
//  Photo.h
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/16/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer, Region;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * recentOrder;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) Photographer *photographer;
@property (nonatomic, retain) Region *region;

@end
