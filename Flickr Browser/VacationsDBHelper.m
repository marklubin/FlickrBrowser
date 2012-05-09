//
//  VacationsDBHelper.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/9/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "VacationsDBHelper.h"
#import "Vacation.h"
#define VACATIONS_DATABASE_NAME @"vacations"

@interface VacationsDBHelper ()
@end

@implementation VacationsDBHelper

+(void)returnOpenedDocumentToObject:(id)object
                       withSelector:(SEL)selector
                    managedDocument:(UIManagedDocument *)db
{   
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//supressed warning about memory management
    
    //call the method provided to me with 
    [object performSelector:selector withObject:db];
    
#pragma clang diagnostic pop
}

+(void)openVacationsDBwithCallbackto:(id)object
                       usingSelector:(SEL)selector
{
    //open document
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:VACATIONS_DATABASE_NAME];
    UIManagedDocument *db = [[UIManagedDocument alloc]initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [db saveToURL:url forSaveOperation:UIDocumentSaveForCreating 
            completionHandler:^(BOOL success){
                if(success) [self returnOpenedDocumentToObject:object 
                                                  withSelector:selector 
                                               managedDocument:db];
            
        
        }];
        
    } else if(db.documentState == UIDocumentStateClosed){
        [db openWithCompletionHandler:^(BOOL success){
            if(success) [self returnOpenedDocumentToObject:object 
                                              withSelector:selector 
                                           managedDocument:db];
            
            
        }];
    
    }else if(db.documentState == UIDocumentStateNormal){
        [self returnOpenedDocumentToObject:object 
                              withSelector:selector 
                           managedDocument:db];    
    }
  
    
}


@end
