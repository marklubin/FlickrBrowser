//
//  Photo.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/9/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSData * unique;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
