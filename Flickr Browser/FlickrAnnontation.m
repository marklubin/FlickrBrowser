//
//  FlickrAnnontation.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/3/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FlickrAnnontation.h"
#import "FlickrFetcher.h"

@implementation FlickrAnnontation
@synthesize photo = _photo;
@synthesize coordinate = _coordinate;


+(id<MKAnnotation>)flickrAnnotationForPhoto:(NSDictionary *)photo{
    FlickrAnnontation *annotation = [[FlickrAnnontation alloc]init];
    annotation.photo = photo;
    annotation.coordinate = CLLocationCoordinate2DMake([[photo objectForKey:FLICKR_LATITUDE] doubleValue],
                                                       [[photo objectForKey:FLICKR_LONGITUDE] doubleValue]);
    
    return annotation;
    
}

-(NSString *)title{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

-(NSString *)subtitle{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

@end
