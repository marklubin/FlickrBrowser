//
//  FlickrPhotoViewController.m
//  Flickr Browser
//
//  Created by Mark Lubin on 4/30/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "FlickrPhotoViewController.h"

@interface FlickrPhotoViewController ()

@end

@implementation FlickrPhotoViewController
@synthesize toolbar = _toolbar;
@synthesize imageLabel = _imageLabel;
@synthesize image = _image;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;


-(void)setImage:(UIImage *)image{
    if(_image != image){
        _image = image;
    }
    if(_image && self.imageView){//if i have an image view to do it in
        [self updateImage];
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


-(void) splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    NSMutableArray *items = [self.toolbar.items mutableCopy];
    barButtonItem.title = @"Photos";
    [items insertObject:barButtonItem atIndex:0];
    self.toolbar.items = items;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [self.toolbar.items mutableCopy];
    [items removeObject:barButtonItem];
    self.toolbar.items = items;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //set myself up as the delegate for splitview and scrollview
    self.splitViewController.delegate = self;   
    self.scrollView.delegate =self;
    if(self.image){
        [self updateImage];
    }
}

-(void)updateImage{
    self.imageView.image = self.image;
    //TODO set frame and scrollview up
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setImageLabel:nil];
    [self setScrollView:nil];
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
