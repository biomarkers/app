//
//  JKKCalibrationListViewController.h
//  App
//
//  Created by Kevin on 3/12/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKModel.h"
#import "JKKTestViewController.h"

@interface JKKCalibrationListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)unwindToCalibrationList:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UITableView *calibrationTable;

@property (strong, nonatomic) IBOutlet UITextView *calibrationStatsTextView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property JKKModel* test;

@end
