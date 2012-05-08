//
//  TagsTVC.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "Photo.h"
#import "Vacation.h"
#import "CoreDataTableViewController.h"

@interface TagsTVC : CoreDataTableViewController
@property Vacation *vacation;

@end
