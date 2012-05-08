//
//  Vacation.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Vacation : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *places;
@end

@interface Vacation (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(Place *)value;
- (void)removePlacesObject:(Place *)value;
- (void)addPlaces:(NSSet *)values;
- (void)removePlaces:(NSSet *)values;

@end
