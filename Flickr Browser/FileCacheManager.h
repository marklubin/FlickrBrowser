//
//  FileCacheManager.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/4/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCacheManager : NSObject

//to do add designated initializer that specifies where to look for cache
-(FileCacheManager *)initWithCacheDirectoryName:(NSString *)directoryName;
-(BOOL)cacheContainsFileWithUniqueIdentifier:(NSString *)identifier;
-(NSData *)dataForFileWithUniqueIdentifier:(NSString *)identifier;
-(void)saveDataToCache:(NSData *)data withUniqueIdentifier:(NSString *)identifier;

@end
