//
//  VacationPhotosTVC.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "VacationPhotosTVC.h"

@interface VacationPhotosTVC ()

@end

@implementation VacationPhotosTVC
@synthesize predicate = _predicate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //set title

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //set the imageview
}

@end
