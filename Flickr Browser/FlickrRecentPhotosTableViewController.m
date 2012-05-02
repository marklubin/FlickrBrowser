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


-(UIImage *)loadPreviewImage:(NSIndexPath *)indexPath{
    return  [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatSquare];
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
    dispatch_queue_t queue = dispatch_queue_create("imagePreview", NULL);
    dispatch_async(queue, ^{
        UIImage *image = [self loadPreviewImage:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[self.tableView indexPathForCell:cell] isEqual:indexPath]){
                cell.imageView.image = image;
                [cell setNeedsLayout];
                
            }
        });
    });
    dispatch_release(queue);
    
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.splitViewController){//if im on the ipad
        FlickrPhotoViewController *fpVC = [self.splitViewController.viewControllers lastObject];
        fpVC.imageTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        dispatch_queue_t queue = dispatch_queue_create("getPhoto", NULL);
        dispatch_async(queue, ^{
            UIImage *image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
            if([self.tableView.indexPathForSelectedRow isEqual:indexPath]){
                //if i'm still the selected row after i've grabbed the image the show it and add to recents
                dispatch_async(dispatch_get_main_queue(), ^{
                    fpVC.image = image;
                });
                
            }
            
        });
         dispatch_release(queue);
        
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowRecentImage"]){
        FlickrPhotoViewController *fpVC = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        dispatch_queue_t queue = dispatch_queue_create("getPhoto", NULL);
        dispatch_async(queue, ^{
            UIImage *image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
            if([self.tableView.indexPathForSelectedRow isEqual:indexPath]){
                //if i'm still the selected row after i've grabbed the image the show it and add to recents
                dispatch_async(dispatch_get_main_queue(), ^{
                    fpVC.image = image;
                });
                
            }
            
        });
         dispatch_release(queue);
        

    }
}






- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        NSMutableArray *photos = [self.photos mutableCopy];
        [photos removeObject:[self.photos objectAtIndex:indexPath.row]];
        self.photos = photos;
        [defaults removeObjectForKey:@"RecentPhotos"];
        [defaults setObject:photos forKey:@"RecentPhotos"];
         
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
   
}




@end
