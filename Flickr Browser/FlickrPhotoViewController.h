//
//  FlickrPhotoViewController.h
//  Flickr Browser
//
//  Created by Mark Lubin on 4/30/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FlickrPhotoViewController : UIViewController
    <UISplitViewControllerDelegate,UIScrollViewDelegate>;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (strong, nonatomic) UIImage *image;
@property (strong,nonatomic) NSString *imageTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
