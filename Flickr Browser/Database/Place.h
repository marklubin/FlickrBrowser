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
@property (nonatomic, retain) NSOrderedSet *vacations;
@property (nonatomic, retain) NSOrderedSet *photos;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)insertObject:(Vacation *)value inVacationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromVacationsAtIndex:(NSUInteger)idx;
- (void)insertVacations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeVacationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInVacationsAtIndex:(NSUInteger)idx withObject:(Vacation *)value;
- (void)replaceVacationsAtIndexes:(NSIndexSet *)indexes withVacations:(NSArray *)values;
- (void)addVacationsObject:(Vacation *)value;
- (void)removeVacationsObject:(Vacation *)value;
- (void)addVacations:(NSOrderedSet *)values;
- (void)removeVacations:(NSOrderedSet *)values;
- (void)insertObject:(Photo *)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(Photo *)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray *)values;
- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSOrderedSet *)values;
- (void)removePhotos:(NSOrderedSet *)values;
@end
