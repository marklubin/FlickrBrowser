//
//  VacationsTVC.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "VacationsTVC.h"
#import "FlickrPhotoViewController.h"

@interface VacationsTVC ()<VacationPhotoStatusDelagate>

@end

@implementation VacationsTVC

-(void)awakeFromNib{
    //set my self up as the photo status delagate for the image view when i wake up
    
    FlickrPhotoViewController *fPTVC =  [self.splitViewController.viewControllers lastObject];
    fPTVC.vacationPhotoStatusDelagate = self;
    //when i load get my vacations create the file if it doesn't exists and create a default vacation if there are none

}
-(BOOL)photoIsVisited:(id)photo{
    //make sure its an NSDictionary
    //return whether or not this photo exists in my database
    //TODO change this so the imageview has the photo dictionary and this method accepts it
    return YES;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
