//
//  Region.h
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 7/5/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Photographer *photographers;

@end
