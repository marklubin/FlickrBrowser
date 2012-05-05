//
//  MapViewController.m
//  Flickr Browser
//
//  Created by Mark Lubin on 5/3/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "math.h"
#define STREET_MAP_SELECTED 0
#define SAT_MAP_SELECTED 1
#define HYBRID_MAP_SELECTED 2


@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delagate = _delagate;

- (IBAction)mapTypeSelectorChanged:(UISegmentedControl *)sender {
    //y you no show up?
    int mapType = sender.selectedSegmentIndex;
    if(mapType == STREET_MAP_SELECTED) self.mapView.mapType = MKMapTypeStandard;
    if(mapType == SAT_MAP_SELECTED) self.mapView.mapType = MKMapTypeSatellite;
    if(mapType == HYBRID_MAP_SELECTED) self.mapView.mapType = MKMapTypeHybrid;
    [self.mapView setNeedsDisplay];
    
    
}

-(MKCoordinateRegion)calculateRegionFromAnnotations{
    //initialize local var i'll use for calculation
    CLLocationDegrees maxLat = 0;
    CLLocationDegrees minLat = 0;
    CLLocationDegrees maxLong = 0;
    CLLocationDegrees minLong = 0;
    
    for (id<MKAnnotation>annotation in self.annotations) {
        //first time through set up my initial values
        if(!maxLat && !minLat && !maxLong && !minLong){
            maxLat = annotation.coordinate.latitude;
            minLat = maxLat;
            maxLong = annotation.coordinate.longitude;
            minLong = maxLong;
        }
        else{//every other time
            if(annotation.coordinate.latitude > maxLat) maxLat = annotation.coordinate.latitude;
            if(annotation.coordinate.latitude < minLat) minLat = annotation.coordinate.latitude;
            if(annotation.coordinate.longitude > maxLong) maxLong = annotation.coordinate.longitude;
            if(annotation.coordinate.longitude < minLong) minLong = annotation.coordinate.longitude;
        }
    }
    CLLocationDegrees latDelta = fabs(maxLat - minLat);
    CLLocationDegrees longDelta = fabs(maxLong - minLong);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(minLat + latDelta/2., minLong + longDelta/2.);
    MKCoordinateSpan span = MKCoordinateSpanMake(latDelta + .05 * latDelta, longDelta + .05 * longDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    return region;
}

-(void)updateMap{
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if(self.annotations) [self.mapView addAnnotations:self.annotations];
    MKCoordinateRegion region =[self.mapView regionThatFits:[self calculateRegionFromAnnotations]];
    [self.mapView setRegion:region];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    }
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}
 -(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    dispatch_queue_t queue = dispatch_queue_create("Thumbnail", NULL);
    dispatch_async(queue, ^{
        id<MKAnnotation> annotation = view.annotation;
        UIImage *image = [self.delagate previewImageForAnnotation:annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(view.annotation == annotation){
                [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
                [view setNeedsLayout];
                
            }
        });
        
    });
    dispatch_release(queue);
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self.delagate disclosureButtonPressedForAnnotation:view.annotation];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.toolbarHidden = YES;
    self.mapView.delegate = self;
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
