//
//  Vacation+Utils.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/9/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "Vacation+Utils.h"

@implementation Vacation (Utils)
+(Vacation *)vacationForString:(NSString *)vacationName
                     inContext:(NSManagedObjectContext *)context{
    //if a vacation by this name exists return it
    //else make it
    Vacation *vacation = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@",vacationName];
    
    NSArray *matches = [context executeFetchRequest:request error:Nil];
    if([matches count] == 1){
        vacation = [matches lastObject];
    }
    else if(![matches count]){
        vacation = [NSEntityDescription insertNewObjectForEntityForName:@"Vacation" 
                                                  inManagedObjectContext:context];
        vacation.title = vacationName;
        
    }
    else{
        // there is an error do something
    }
    return vacation;
}

@end
