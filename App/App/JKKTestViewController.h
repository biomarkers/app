//
//  JKKTestViewController.h
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKTest.h"


@interface JKKTestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) IBOutlet UITextField *nameField;

@property (strong, nonatomic) IBOutlet UILabel *minuteLabel;
@property (strong, nonatomic) IBOutlet UIStepper *minuteStepper;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UIStepper *secondStepper;

@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSelector;
@property (strong, nonatomic) IBOutlet UISegmentedControl *channelSelector;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@property JKKTest* test;

@end
