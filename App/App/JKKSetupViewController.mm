//
//  JKKSetupViewController.m
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKSetupViewController.h"

@interface JKKSetupViewController ()

@end

@implementation JKKSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* hessk: hides the keyboard if the user touches anywhere other than the specified views
 by "resigning" them as "first responders" */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.notesField isFirstResponder] && [touch view] != self.notesField) {
        [self.notesField resignFirstResponder];
    } else if ([self.subjectField isFirstResponder] && [touch view] != self.subjectField) {
        [self.subjectField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    JKKResult* newResult = [[JKKResult alloc] init];
    newResult.date = [NSDate date];
    self.result = newResult;
    
    // hessk: pass pointers on
    if ([[segue identifier] isEqualToString:@"showCameraFromSetup"]) {
        [[segue destinationViewController] setTest:self.test];
        [[segue destinationViewController] setResult:self.result];
        [[segue destinationViewController] setTakingCalibrationPoint:NO];
    }
}

@end
