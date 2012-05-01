//
//  FlickrPlacePhotosViewController.m
//  Flickr Browser
//
//  Created by Mark Lubin on 4/30/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FlickrPlacePhotosViewController.h"
#import "FlickrFetcher.h"
#import "FlickrTopPhotoTableViewController.h"
#import "FlickrPhotoViewController.h"
#define MAX_RESULTS 50

@interface FlickrPlacePhotosViewController()
@property (nonatomic,strong) NSArray *photos;
-(UIImage *)getImageforIndexPath:(NSIndexPath *)indexPath;
@end

@implementation FlickrPlacePhotosViewController
@synthesize reloadButton = _reloadButton;
@synthesize place = _place;
@synthesize photos = _photos;

-(void)setPlace:(NSDictionary *)place{
    if(place != _place){
        _place = place;
        [self refreshTable:self.reloadButton]; //if my place changes update my view
        [self updateTitle];
    }
}
-(IBAction)refreshTable:(UIBarButtonItem *)sender{
    [super refreshTable:sender];
}

-(void)updateTitle{
    NSString *placeStr = [self.place valueForKey:FLICKR_PLACE_NAME];
    NSDictionary *placeDescription = [self parsePlaceName:placeStr];
    self.navigationItem.title = [placeDescription valueForKey:@"locality"];
    
}

-(void)getTableData{
    self.photos = [FlickrFetcher photosInPlace:self.place maxResults:MAX_RESULTS];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateTitle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)                       section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacePhoto";
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

-(UIImage *)getImageforIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [FlickrFetcher urlForPhoto:[self.photos objectAtIndex:indexPath.row] 
                                     format:FlickrPhotoFormatLarge];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.splitViewController){//if im on the ipad
        FlickrPhotoViewController *fpVC = [self.splitViewController.viewControllers lastObject];
        fpVC.imageTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        fpVC.image = [self getImageforIndexPath:indexPath];
        
    }
}
@end
