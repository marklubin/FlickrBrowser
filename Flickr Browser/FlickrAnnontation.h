//
//  FlickrAnnontation.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/3/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrAnnontation : NSObject<MKAnnotation>
@property NSDictionary *photo;
+(id<MKAnnotation>)flickrAnnotationForPhoto:(NSDictionary *)photo;

@end
