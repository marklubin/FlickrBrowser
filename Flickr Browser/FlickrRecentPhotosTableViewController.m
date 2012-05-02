//
//  FlickrRecentPhotosTableViewController.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/1/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FlickrRecentPhotosTableViewController.h"
#import "FlickrPhotoViewController.h"

@interface FlickrRecentPhotosTableViewController ()

@end

@implementation FlickrRecentPhotosTableViewController




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photos = [[[NSUserDefaults alloc]init]arrayForKey:@"RecentPhotos"];
    [self.tableView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"RecentPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *description = [[photo objectForKey:@"description"] objectForKey:@"_content"];
    if([title isEqualToString:@""]){
        title = description;
        description = @"";
        if([title isEqualToString:@""]){
            title = @"Unknown";
        }
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.splitViewController){//if im on the ipad
        FlickrPhotoViewController *fpVC = [self.splitViewController.viewControllers lastObject];
        fpVC.imageTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        fpVC.image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowRecentImage"]){
        FlickrPhotoViewController *fpVC = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        fpVC.imageTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        fpVC.image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
    }
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




@end
