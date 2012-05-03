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

@interface PhotoListTableViewController ()

@end

@implementation PhotoListTableViewController
@synthesize reloadButton = _reloadButton;
@synthesize photos = _photos;

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
    NSURL *url = [FlickrFetcher urlForPhoto:[self.photos objectAtIndex:indexPath.row] 
                                     format:size];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
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
            //create an annotation and add to the list
        }
        MapViewController *mapVC= segue.destinationViewController;
        mapVC.annotations = annotations;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
