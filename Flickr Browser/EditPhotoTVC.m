//
//  EditPhotoTVC.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/8/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "EditPhotoTVC.h"
#import "VacationsDBHelper.h"

@interface EditPhotoTVC ()

@end

@implementation EditPhotoTVC
@synthesize photo = _photo;
@synthesize toDelete = _toDelete;
@synthesize vacationDB = _vacationDB;

-(void)setVacationDB:(UIManagedDocument *)vacationDB{
    _vacationDB = vacationDB;
    //go load myself up with data about each vacation
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [VacationsDBHelper openVacationsDBwithCallbackto:self
                                       usingSelector:@selector(setVacationDB:)];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationPhotoEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = @"";
    
    if(self.toDelete && indexPath.row == 0){
        cell.textLabel.text = @"Remove Photo";
        
    }else if(!self.toDelete){
        //configure cell normally
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.toDelete && indexPath.row == 0){
        //remove photo from database
    }else if(!self.toDelete){
        //add to approriate vacation
    }
}

@end
