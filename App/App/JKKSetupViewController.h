//
//  JKKSetupViewController.h
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//
#pragma once
#import <UIKit/UIKit.h>
#import "JKKCameraViewController.h"
#import "RegressionFactory.h"
#import "JkkModel.h"

@interface JKKSetupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *subjectField;
@property (strong, nonatomic) IBOutlet UITextView *notesField;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;

//@property JKKTest* test;
//@property RegressionModel::RegressionModel* test;
@property JKKModel* test;
@property JKKResult* result;

@end
