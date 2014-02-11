//
//  JKKConfigViewController.h
//  App
//
//  Created by Kevin on 2/10/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKKConfigViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *fpsLabel;
@property (strong, nonatomic) IBOutlet UIStepper *fpsStepper;

@end
