//
//  ImageViewController.m
//  Imaginarum
//
//  Created by Serguei Vinnitskii on 12/1/14.
//  Copyright (c) 2014 Kartoshka. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image; //implemented setter & getter without instance variable property
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.1;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self. imageURL]];
    [self startDownloadingImage];
}

-(void) startDownloadingImage
{
    self.image = nil;
    if (self.imageURL) {
        
        [self.spinner startAnimating]; // spinner to appear
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        // Request URL in separate thread (not MAIN)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([request.URL isEqual:self.imageURL])// Checks if user still wants to download this file or he changed his mind
                    {
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                        dispatch_async(dispatch_get_main_queue(), ^{self.image = image;}); // has to happen on MAIN thread
//                        or it can be done like this:
//                        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                    }
                }
            }];
        [task resume];
    }
}

-(UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

-(UIImage *)image // getter
{
    return self.imageView.image;
}

-(void) setImage:(UIImage *)image // setter
{
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.image.size;
}

#pragma mark - UISplitControllerDelegate

-(void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }
}
@end
