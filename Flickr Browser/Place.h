//
//  Place.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Vacation;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSSet *vacations;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addVacationsObject:(Vacation *)value;
- (void)removeVacationsObject:(Vacation *)value;
- (void)addVacations:(NSSet *)values;
- (void)removeVacations:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
