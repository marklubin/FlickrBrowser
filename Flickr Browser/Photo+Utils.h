//
//  Photo+Utils.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/9/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "Photo.h"

@interface Photo (Utils)
+(Photo *)photoForFlickrPhoto:(NSDictionary *)flickrPhoto;

@end
