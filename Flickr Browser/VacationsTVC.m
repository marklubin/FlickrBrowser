//
//  VacationsTVC.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "VacationsTVC.h"
#import "FlickrPhotoViewController.h"
#import "VacationsDBHelper.h"
#import "Vacation+Utils.h"
#define DEFAULT_VACATION_NAME @"My Vacation"


@interface VacationsTVC ()<VacationPhotoStatusDelagate>

@end

@implementation VacationsTVC
@synthesize vacationsDB = _vacationsDB;


-(void)setVacationsDB:(UIManagedDocument *)vacationsDB{
    _vacationsDB = vacationsDB;
    //set up a default vacation if its not there
    [Vacation vacationForString:DEFAULT_VACATION_NAME 
                      inContext:self.vacationsDB.managedObjectContext];
}

-(void)awakeFromNib{
    //set my self up as the photo status delagate for the image view when i wake up
    
    FlickrPhotoViewController *fPTVC =  [self.splitViewController.viewControllers lastObject];
    fPTVC.vacationPhotoStatusDelagate = self;
    [VacationsDBHelper openVacationsDBwithCallbackto:self
                                       usingSelector:@selector(setVacationsDB:)];
    
    

}
-(BOOL)photoIsVisited:(id)photo{
    if(!self.vacationsDB) return NO; //if i dont have an open document return false
    
    NSDictionary *photoDict = photo;
    NSString *photoID = [photoDict valueForKey:FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSManagedObjectContext *context = self.vacationsDB.managedObjectContext;
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",photoID];
    NSArray *matches = [context executeFetchRequest:request error:Nil];
    return [matches count];

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
