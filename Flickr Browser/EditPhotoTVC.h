//
//  EditPhotoTVC.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vacation.h"
#import "Photo.h"
#import "CoreDataTableViewController.h"

@interface EditPhotoTVC : CoreDataTableViewController
@property NSDictionary *photo;
@property BOOL toDelete;


@end
