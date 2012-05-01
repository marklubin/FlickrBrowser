//
//  FlickrTopPhotoTableViewController.m
//  Flickr Browser
//
//  Created by Mark Lubin on 4/30/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FlickrTopPhotoTableViewController.h"
#import "FlickrPlacePhotosViewController.h"
#import "FlickrFetcher.h"

@interface FlickrTopPhotoTableViewController ()

@property (strong,nonatomic) NSArray *places;

@end

@implementation FlickrTopPhotoTableViewController
@synthesize reloadButton = _reloadButton;
@synthesize places = _places;


- (IBAction)refreshTable:(UIBarButtonItem *)sender {
    [super refreshTable:sender];
    
}


-(void)getTableData{
    self.places = [FlickrFetcher topPlaces];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *row = self.tableView.indexPathForSelectedRow;
    NSDictionary *placeToSend = [self.places objectAtIndex:row.row];
    if([segue.identifier isEqualToString:@"ShowPlace"]){
        FlickrPlacePhotosViewController *placeVC = segue.destinationViewController;
        placeVC.place = placeToSend;
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self refreshTable:self.reloadButton];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TopPlacesPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    NSDictionary *placeDescription = [self parsePlaceName:[place objectForKey:FLICKR_PLACE_NAME]];
    cell.textLabel.text = [placeDescription objectForKey:@"locality"];
    cell.detailTextLabel.text = [placeDescription objectForKey:@"region"];
    
    
    return cell;
}



#pragma mark - Table view delegate



@end
