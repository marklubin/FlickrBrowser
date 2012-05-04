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
#define MAX_RESULTS 200
#define RESULTS_PER_LOAD 50

//TODO enable loading of more photos

@interface FlickrPlacePhotosViewController()
@property NSUInteger resultsToDisplay;
@end

@implementation FlickrPlacePhotosViewController
@synthesize morePhotosButton = _morePhotosButton;
@synthesize reloadButton = _reloadButton;
@synthesize place = _place;
@synthesize resultsToDisplay = _resultsToDisplay;


-(void)setPlace:(NSDictionary *)place{
    if(place != _place){
        _place = place;
        [self refreshTable:self.reloadButton]; //if my place changes update my view
        [self updateTitle];
    }
}
-(IBAction)refreshTable:(UIBarButtonItem *)sender{
    if(!self.resultsToDisplay) self.resultsToDisplay = RESULTS_PER_LOAD;
    [super refreshTable:sender];
}

- (IBAction)morePhotoPressed:(UIButton *)sender {//a bad implementation of loading more results
    if(self.resultsToDisplay + RESULTS_PER_LOAD >= MAX_RESULTS){
        self.resultsToDisplay = MAX_RESULTS;
        self.morePhotosButton.hidden = YES;
        [self.morePhotosButton setNeedsDisplay];
    } else{
        self.resultsToDisplay += RESULTS_PER_LOAD;
    }
    [self refreshTable:self.reloadButton];
   
}


 
-(UIImage *)loadPreviewImage:(NSIndexPath *)indexPath{
  return  [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatSquare];
}

-(void)updateTitle{
    NSString *placeStr = [self.place valueForKey:FLICKR_PLACE_NAME];
    NSDictionary *placeDescription = [self parsePlaceName:placeStr];
    self.navigationItem.title = [placeDescription valueForKey:@"locality"];
    
}

-(void)getTableData{
    self.photos = [FlickrFetcher photosInPlace:self.place maxResults:self.resultsToDisplay];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if(self.photos){
        [self updateTitle];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
        
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner startAnimating];
        spinner.center = fpVC.scrollView.center;
        [fpVC.view addSubview:spinner];

                
        dispatch_queue_t queue = dispatch_queue_create("getPhoto", NULL);
        dispatch_async(queue, ^{
            
            UIImage *image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
           
                //if i'm still the selected row after i've grabbed the image the show it and add to recents
                dispatch_async(dispatch_get_main_queue(), ^{
                     if([self.tableView.indexPathForSelectedRow isEqual:indexPath]){
                         fpVC.image = image;
                         [self updateRecents:indexPath];
                     }
                    [spinner removeFromSuperview];
                });
           
        }); 
         dispatch_release(queue);
       
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender]; //try my subclass for the mapView segue
    
    if([segue.identifier isEqualToString:@"ShowImage"]){
        FlickrPhotoViewController *fpVC = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        fpVC.imageTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        
     
        dispatch_queue_t queue = dispatch_queue_create("getPhoto", NULL);
        dispatch_async(queue, ^{
            UIImage *image = [self getImageforIndexPath:indexPath withSize:FlickrPhotoFormatLarge];
            if([self.tableView.indexPathForSelectedRow isEqual:indexPath]){
                //if i'm still the selected row after i've grabbed the image the show it and add to recents
                dispatch_async(dispatch_get_main_queue(), ^{
                    fpVC.image = image;
                    [self updateRecents:indexPath];
                });
                
            }
            
        });
        dispatch_release(queue);

    
    }
}
- (void)viewDidUnload {
    [self setMorePhotosButton:nil];
    [super viewDidUnload];
}
@end
