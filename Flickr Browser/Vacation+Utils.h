//
//  Vacation+Utils.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/9/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "Vacation.h"

@interface Vacation (Utils)
+(Vacation *)vacationForString:(NSString *)vacationName
                     inContext:(NSManagedObjectContext *)context;

@end
