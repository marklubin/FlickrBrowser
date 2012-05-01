//
//  PhotoListTableViewController.h
//  Flickr Browser
//
//  Created by Mark Lubin on 4/30/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoListTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;

-(NSDictionary *)parsePlaceName:(NSString *)place;

//overwrite
-(void)getTableData;

//handles refreshing and displaying indicator
- (IBAction)refreshTable:(UIBarButtonItem *)sender;

- (void)viewDidLoad;

- (void)viewDidUnload;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) //returns YES for all Orientations
                                                toInterfaceOrientation;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; //returns 1

//need to overwrite
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; //returns 0

//need to overwrite
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


//table editting not implemented in this class
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:
                                                                            (NSIndexPath *)toIndexPath;

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;








@end
