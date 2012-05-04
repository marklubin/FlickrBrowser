//
//  PhotoListTableViewController.m
//  Flickr Browser
//
//  Created by Mark Lubin on 4/30/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "PhotoListTableViewController.h"
#import "FlickrFetcher.h"
#import "MapViewController.h"
#import "FlickrAnnotation.h"
#import "FileCacheManager.h"

@interface PhotoListTableViewController ()<MapViewControllerDelagate,UIPopoverControllerDelegate>
@property UIPopoverController *popover;
@property (nonatomic,strong) FileCacheManager *cacheManager;
@end

@implementation PhotoListTableViewController
@synthesize reloadButton = _reloadButton;
@synthesize photos = _photos;
@synthesize popover = _popover;
@synthesize cacheManager = _cacheManager;

-(FileCacheManager *)cacheManager{//lazily instaniate cache manager
    //todo maybe change to designated initializer that specifies cache
    if(!_cacheManager) _cacheManager = [[FileCacheManager alloc]init];
    return _cacheManager;
}


- (IBAction)refreshTable:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    //put this call in seperate thread
    dispatch_queue_t queue = dispatch_queue_create("flickrNetworking", NULL);
    dispatch_async(queue, ^{
         [self getTableData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            [self.tableView reloadData];
        });
    });
    dispatch_release(queue);
   
  
    
}

-(UIImage *)getImageforIndexPath:(NSIndexPath *)indexPath withSize:(FlickrPhotoFormat)size{
    UIImage *image;
    NSData *data;
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *photoID = [photo valueForKey:FLICKR_PHOTO_ID];
    
    
    if(size == FlickrPhotoFormatLarge
        && [self.cacheManager cacheContainsFileWithUniqueIdentifier:photoID]){
        
        //only want to get from the cache for large images
        data = [self.cacheManager dataForFileWithUniqueIdentifier:photoID];
        
    }else{
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:size];
        data = [NSData dataWithContentsOfURL:url];
        
          //if i don't have it in the cache and its large let cacheManger save it
        if(size == FlickrPhotoFormatLarge){
            [self.cacheManager saveDataToCache:data:[photo valueForKey:FLICKR_PHOTO_ID]];
        }
        
    }
    
    image = [UIImage imageWithData:data];
    return image;
}

-(UIImage *)previewImageForAnnotation:(id<MKAnnotation>)annotation{
    NSDictionary *photo = [(FlickrAnnotation *)annotation photo];
    NSInteger row = [self.photos indexOfObject:photo];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
    return [self getImageforIndexPath:indexpath withSize:FlickrPhotoFormatSquare];
}

-(void)disclosureButtonPressedForAnnotation:(id<MKAnnotation>)annotation{
    //keep the UI in sync by manually selecting the row
    NSDictionary *photo = [(FlickrAnnotation *)annotation photo];
    NSInteger row = [self.photos indexOfObject:photo];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionTop];
    if(self.splitViewController){
        //dismiss the popover and show the photo
        [self.popover dismissPopoverAnimated:YES];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexpath];
    }
    else{
        [self performSegueWithIdentifier:@"ShowImage" sender:self];
    }
    
}

-(NSDictionary *)parsePlaceName:(NSString *)place{
    NSMutableDictionary *placeDescription = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSArray *description = [place componentsSeparatedByString:@","];
    NSString *locality = [description objectAtIndex:0];
    [placeDescription setObject:locality forKey:@"locality"];
    NSMutableString *region = [[NSMutableString alloc] initWithString:[description objectAtIndex:1]];
    for(int i = 2; i < description.count; i++){
        [region appendFormat:@",%@",[description objectAtIndex:i]];
    }
    [placeDescription setObject:region forKey:@"region"];
    return placeDescription;
}




-(void)getTableData{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.toolbar setTintColor:[UIColor blackColor]];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowMap"]){
        NSMutableArray *annotations = [[NSMutableArray alloc]initWithCapacity:self.photos.count];
        for (NSDictionary *photo in self.photos) {
            [annotations addObject:[FlickrAnnotation flickrAnnotationForPhoto:photo]];
        }
        MapViewController *mapVC= segue.destinationViewController;
        mapVC.annotations = annotations;
        mapVC.delagate = self;
        if(self.splitViewController){//if im on ipad
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
            self.popover = popoverSegue.popoverController;
        }
    }
                                            
}

- (void)viewDidUnload
{
    [self setReloadButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


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



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

@end
