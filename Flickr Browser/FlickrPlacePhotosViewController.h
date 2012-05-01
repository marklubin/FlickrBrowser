//
//  FlickrPlacePhotosViewController.h
//  Flickr Browser
//
//  Created by Mark Lubin on 4/30/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoListTableViewController.h"

@interface FlickrPlacePhotosViewController: PhotoListTableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (strong,nonatomic) NSDictionary *place;
@end
