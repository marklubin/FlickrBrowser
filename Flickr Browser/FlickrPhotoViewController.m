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
@synthesize imageTitle = _imageTitle;


-(void)setImage:(UIImage *)image{
    if(_image != image){
        _image = image;
    }
    if(_image && self.imageView){//if i have an image view to do it in
        [self updateImage];
    }
}

-(void)setImageTitle:(NSString *)imageTitle{
    _imageTitle = imageTitle;
    self.imageLabel.text = self.imageTitle;
    self.navigationItem.title = self.imageTitle;
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
    scrollView.contentScaleFactor = 1;
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
    self.splitViewController.presentsWithGesture = NO;
    if(self.image){
        [self updateImage];
    }
}


-(void)updateImage{//fix scrolling on iphone
    self.scrollView.contentSize = self.image.size;
    self.imageView.image = self.image;
    self.imageView.frame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, self.imageView.image.size.width, self.imageView.image.size.height);
    //NSLog(@"%g,%g",self.imageView.frame.origin.x,self.imageView.frame.origin.y);
    [self.scrollView zoomToRect:self.imageView.frame animated:NO];
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
