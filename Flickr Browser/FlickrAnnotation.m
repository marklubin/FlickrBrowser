//
//  FlickrAnnontation.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/3/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FlickrAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrAnnotation
@synthesize photo = _photo;
@synthesize coordinate = _coordinate;


+(id<MKAnnotation>)flickrAnnotationForPhoto:(NSDictionary *)photo{
    FlickrAnnotation *annotation = [[FlickrAnnotation alloc]init];
    annotation.photo = photo;
    return annotation;
    
}

-(NSString *)title{
    //you need a title for the Callout to show so Make sure it is set to something besides the empty string
    NSString *title = [self.photo objectForKey:FLICKR_PHOTO_TITLE];
    if([title isEqualToString:@""]) title = [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if([title isEqualToString:@""]) title = @"Unknown";
    return title;
}

-(NSString *)subtitle{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate =   
    CLLocationCoordinate2DMake([[self.photo objectForKey:FLICKR_LATITUDE] doubleValue],
                               [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue]);
    return coordinate;
}


@end
