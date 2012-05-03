//
//  MapViewController.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/3/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;

-(MKCoordinateRegion)calculateRegionFromAnnotations{
    MKCoordinateRegion region;
    return region;
    
}

-(void)updateMap{
    if(self.annotations){
        [self.mapView addAnnotations:self.annotations];
    }
    self.mapView.region = [self calculateRegionFromAnnotations];
}

-(void)setMapView:(MKMapView *)mapView{
    if(_mapView != mapView){
        _mapView = mapView;
        [self updateMap];
    }
}

-(void)setAnnotations:(NSArray *)annotations{
    if(_annotations != annotations){
        _annotations = annotations;
        [self updateMap];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.toolbarHidden = YES;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
