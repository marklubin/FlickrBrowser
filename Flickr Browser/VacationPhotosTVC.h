//
//  VacationPhotosTVC.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Place.h"
#import "Tag.h"
#import "CoreDataTableViewController.h"

@interface VacationPhotosTVC : CoreDataTableViewController
@property NSPredicate *predicate;

@end
