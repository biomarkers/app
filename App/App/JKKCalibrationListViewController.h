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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *finishButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showGraphButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *graphModelButton;
@property (strong, nonatomic) IBOutlet UIButton *setTypeButton;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@property JKKModel* test;

@end
