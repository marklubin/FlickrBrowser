//
//  FileCacheManager.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/4/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FileCacheManager.h"

//figure out what sort of number this needs to be
#define MAX_CACHE_SIZE

@implementation FileCacheManager

-(BOOL)cacheContainsFileWithUniqueIdentifier:(NSString *)identifier{
    //check if cache contains file with the identifier
    return NO;
}

-(NSData *)dataForFileWithUniqueIdentifier:(NSString *)identifier{
   //return data for the file
    NSData *data;
    return data;
}

-(void)saveDataToCache:(NSData *)withUniqueIdentifier :(NSString *)identifier{
    //check if cache already contains a file with this ID
    //make sure the cache doesn't exceed MAX_CACHE_SIZE
    //write file to disk
}
@end
