//
//  VacationsDBHelper.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/9/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VacationsDBHelper : NSObject

//calls provided method once document is opened
+(void)openVacationsDBwithCallbackto:(id)object
                       usingSelector:(SEL)selector;

@end
