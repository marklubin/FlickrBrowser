//
//  MapViewController.h
//  Flickr Browser
//
//  Created by Mark Lubin on 5/3/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelagate <NSObject>
-(UIImage *)previewImageForAnnotation:(id<MKAnnotation>)annotation;
-(void)disclosureButtonPressedForAnnotation:(id<MKAnnotation>)annotation;
@end

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSArray *annotations;
@property (weak,nonatomic) id<MapViewControllerDelagate>delagate;

@end
