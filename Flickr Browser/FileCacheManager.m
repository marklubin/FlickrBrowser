//
//  FileCacheManager.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/4/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FileCacheManager.h"

@interface FileCacheManager() 
@property NSFileManager *fileManager;

@end

//figure out what sort of number this needs to be
#define MAX_CACHE_SIZE

@implementation FileCacheManager
const NSSearchPathDirectory cacheDirectory = NSCachesDirectory;


@synthesize fileManager = _fileManager;

-(FileCacheManager *)initWithCacheDirectoryName:(NSString *)directoryName{
    if(self = [super init]){
        //init if the directory doesn't exist create it
    }
    return self;
}

-(NSFileManager *)fileManager{
    if(!_fileManager)_fileManager = [[NSFileManager alloc]init];
    return _fileManager;
}

-(BOOL)cacheContainsFileWithUniqueIdentifier:(NSString *)identifier{
    //check if cache contains file with the identifier
    return NO;
}

-(NSData *)dataForFileWithUniqueIdentifier:(NSString *)identifier{
   //return data for the file
    NSData *data;
    return data;
}

-(void)saveDataToCache:(NSData *)data withUniqueIdentifier :(NSString *)identifier{
    //check if cache already contains a file with this ID
    //make sure the cache doesn't exceed MAX_CACHE_SIZE
    //write file to disk
}
@end
