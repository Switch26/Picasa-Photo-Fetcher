//
//  DetailViewController.h
//  ShutterBug_my
//
//  Created by Serguei Vinnitskii on 12/10/14.
//  Copyright (c) 2014 Kartoshka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

