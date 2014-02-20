//
//  JKKTestViewController.h
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//
#pragma once
#import <UIKit/UIKit.h>
#import "JKKModel.h"
#import "RegressionFactory.h"

@interface JKKTestViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UITextField *nameField;

@property (strong, nonatomic) IBOutlet UILabel *componentsLabel;
@property (strong, nonatomic) IBOutlet UITableView *componentsTable;
@property (strong, nonatomic) IBOutlet UIButton *addComponentButton;

@property (strong, nonatomic) IBOutlet UILabel *calibrationValuesLabel;
@property (strong, nonatomic) IBOutlet UIButton *addCalibrationButton;

@property JKKModel* test;

@end
