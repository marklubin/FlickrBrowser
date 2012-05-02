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
@property (nonatomic,strong) NSMutableDictionary *previewImages;

@end

@implementation FlickrPlacePhotosViewController
@synthesize reloadButton = _reloadButton;
@synthesize place = _place;
@synthesize previewImages = _previewImages;

-(NSMutableDictionary *)previewImages{
    if(_previewImages) return _previewImages;
    else _previewImages = [[NSMutableDictionary alloc]init];
    return _previewImages;
}

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

/*
 Future Feature Load Preview Images Async
 
 -(void)loadPreviewImages{
    //TODO Cache Preview images
    for(int i = 0; i < self.photos.count; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [spinner startAnimating];
        [cell.contentView addSubview:spinner];
        [cell setNeedsLayout];
        NSDictionary *photo = [self.photos objectAtIndex:i];
            if(![self.previewImages valueForKey:[photo valueForKey:FLICKR_PHOTO_ID]]){
                UIImage *image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatSquare];
                [self.previewImages setValue:image forKey:[photo valueForKey:FLICKR_PHOTO_ID]];
           
        
        
    }
}*/

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
    if(self.photos){
        [self updateTitle];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)                       section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"PlacePhoto";
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

-(void)updateRecents:(NSIndexPath *)indexPath{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSMutableArray *recents = [[defaults arrayForKey:@"RecentPhotos"] mutableCopy];
    
    if(!recents){//create if this is our first go around
        recents =  [[NSMutableArray alloc]init];
    }
    
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *photoID = [photo valueForKey:FLICKR_PHOTO_ID];
    //check for dupes
    BOOL shouldAdd = YES;
    for (NSDictionary *currentPhoto in recents) {
        if([photoID isEqualToString:[currentPhoto objectForKey:FLICKR_PHOTO_ID]]){
            shouldAdd = NO;
        }
    }
    //if this isn't a duplicate
    if(shouldAdd)[recents insertObject:photo atIndex:0];
    
    if([recents count] > 20){//trim array if its > 20
        NSRange range;
        range.location = 20;
        range.length = [recents count] - 20;
        [recents removeObjectsInRange:range];
    }
    
    //update my defaults
    [defaults setValue:recents forKey:@"RecentPhotos"];
    [defaults synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.splitViewController){//if im on the ipad
        FlickrPhotoViewController *fpVC = [self.splitViewController.viewControllers lastObject];
        fpVC.imageTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        fpVC.image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
        [self updateRecents:indexPath];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowImage"]){
        FlickrPhotoViewController *fpVC = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        fpVC.imageTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        fpVC.image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
        [self updateRecents:indexPath];
    }
}
@end
