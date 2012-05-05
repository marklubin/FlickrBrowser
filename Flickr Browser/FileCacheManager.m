//
//  FileCacheManager.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/4/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FileCacheManager.h"

@interface FileCacheManager() 
@property (nonatomic,strong) NSFileManager *fileManager;
@property (nonatomic,strong) NSURL *cacheDirectoryPath;

@end

//figure out what sort of number this needs to be
#define MAX_CACHE_SIZE 5.0e+08

@implementation FileCacheManager

@synthesize cacheDirectoryPath = _cacheDirectoryPath;
@synthesize fileManager = _fileManager;

-(NSFileManager *)fileManager{
    if(!_fileManager)_fileManager = [[NSFileManager alloc]init];
    return _fileManager;
}

-(FileCacheManager *)initWithCacheDirectoryName:(NSString *)directoryName{
    if(self = [super init]){
        NSURL *caches = [[self.fileManager URLsForDirectory:NSCachesDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
        NSString *cPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[caches path], directoryName, nil]];
        self.cacheDirectoryPath = [NSURL fileURLWithPath:cPath isDirectory:YES];
        if(![self.fileManager fileExistsAtPath:[self.cacheDirectoryPath path]]){
            [self.fileManager createDirectoryAtURL:self.cacheDirectoryPath
                       withIntermediateDirectories:NO 
                                        attributes:Nil 
                                             error:Nil];
        }
                                        
        
    }
    return self;
}

-(void)removeOldestFile{
    NSString *pathToOldestFile;
    NSDate *oldestDate = Nil;
    NSArray *filepaths = [self.fileManager contentsOfDirectoryAtPath:[self.cacheDirectoryPath path] 
                                                               error:Nil];    
    for(NSString *filePath in filepaths){
        NSString *path = [NSString pathWithComponents:[NSArray arrayWithObjects:[self.cacheDirectoryPath path],filePath, nil]];
        NSDictionary *attributes = [self.fileManager attributesOfItemAtPath:path 
                                                                      error:Nil];
        NSDate *fileDate = [attributes valueForKey:NSFileCreationDate];
        if(!oldestDate) oldestDate = fileDate;
        if([fileDate earlierDate:oldestDate] == fileDate){
            oldestDate = fileDate;
            pathToOldestFile = path;
        }
        
    }
    [self.fileManager removeItemAtPath:pathToOldestFile error:Nil];
   // NSLog(@"Removed file at: %@",pathToOldestFile);
   // NSLog(@"Cache Size = %g",[self sizeOfCacheDirectory]);
    
}

-(double)sizeOfCacheDirectory{
    double cacheSize = 0;
    NSArray *filepaths = [self.fileManager contentsOfDirectoryAtPath:[self.cacheDirectoryPath path] 
                                                               error:Nil];    
    for(NSString *filePath in filepaths){
        NSString *path = [NSString pathWithComponents:[NSArray arrayWithObjects:[self.cacheDirectoryPath path],filePath, nil]];
        NSDictionary *attributes = [self.fileManager attributesOfItemAtPath:path 
                                                                     error:Nil];
        NSNumber *size = [attributes valueForKey:NSFileSize];
        cacheSize += [size doubleValue];
        
    }
    return cacheSize;
}

-(BOOL)cacheContainsFileWithUniqueIdentifier:(NSString *)identifier{
    NSString *filepath = [NSString pathWithComponents:[NSArray arrayWithObjects:[self.cacheDirectoryPath path],identifier, nil]];
    return [self.fileManager fileExistsAtPath:filepath];
    
}


-(NSData *)dataForFileWithUniqueIdentifier:(NSString *)identifier{
   //return data for the file
    NSString *filepath = [NSString pathWithComponents:[NSArray arrayWithObjects:[self.cacheDirectoryPath path],identifier, nil]];
    NSURL *url = [NSURL fileURLWithPath:filepath isDirectory:NO];
    NSData *data = [NSData dataWithContentsOfURL:url];
    //NSLog(@"Returning cached file: %@", filepath);
    return data;
}

-(void)saveDataToCache:(NSData *)data withUniqueIdentifier :(NSString *)identifier{
    NSString *filepath = [NSString pathWithComponents:[NSArray arrayWithObjects:[self.cacheDirectoryPath path],identifier, nil]];
    if(![self.fileManager fileExistsAtPath:filepath]){
        [self.fileManager createFileAtPath:filepath contents:data attributes:nil];
      //  NSLog([self.cacheDirectoryPath path]);
       // NSLog(@"Caching data at file with path: %@",filepath);
        //NSLog(@"Cache Size = %g",[self sizeOfCacheDirectory]);
    }
    //remove oldest item if cache is too big
    if([self sizeOfCacheDirectory] >= MAX_CACHE_SIZE) [self removeOldestFile];

}
@end
