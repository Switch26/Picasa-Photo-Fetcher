//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Serguei Vinnitskii on 12/4/14.
//  Copyright (c) 2014 Kartoshka. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotos];
}

- (IBAction)fetchPhotos {
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jasonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jasonResults
                                                                            options:0
                                                                              error:NULL];
        //NSLog(@"%@", propertyListResults);
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
