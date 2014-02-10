//
//  JKKAddComponentViewController.h
//  App
//
//  Created by Kevin on 2/8/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKComponent.h"

@interface JKKAddComponentViewController : UIViewController

@property JKKComponent* component;

/* button controls */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

/* end time controls */
@property (strong, nonatomic) IBOutlet UILabel *minuteLabel;
@property (strong, nonatomic) IBOutlet UIStepper *minuteStepper;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UIStepper *secondStepper;

/* start time controls */
@property (strong, nonatomic) IBOutlet UILabel *startMinuteLabel;
@property (strong, nonatomic) IBOutlet UIStepper *startMinuteStepper;
@property (strong, nonatomic) IBOutlet UILabel *startSecondLabel;
@property (strong, nonatomic) IBOutlet UIStepper *startSecondStepper;

/* type and color channel controls */
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSelector;
@property (strong, nonatomic) IBOutlet UISegmentedControl *channelSelector;

@end
