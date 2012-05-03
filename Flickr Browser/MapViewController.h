//
//  MapViewController.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/3/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSArray *annotations;

@end
