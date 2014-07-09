//
//  Region.h
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/8/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Photo *photos;

@end
