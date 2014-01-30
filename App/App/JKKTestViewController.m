//
//  JKKTestViewController.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKTestViewController.h"
#import "JKKCameraViewController.h"

@interface JKKTestViewController ()

@property NSInteger currentRuntimeMinutes;
@property NSInteger currentRuntimeSeconds;

@end

@implementation JKKTestViewController

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
    
    
    
    [self populateControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* hessk: called initially to match interface to current JKKTest and do other UI config */
- (void)populateControls {
    if (self.test != nil) {
        self.navBar.title = self.test.name;
        self.nameField.text = self.test.name;
        
        self.currentRuntimeMinutes = floor(self.test.runtime / 60);
        self.currentRuntimeSeconds = trunc(self.test.runtime - self.currentRuntimeMinutes * 60);
        
        self.minuteStepper.value = self.currentRuntimeMinutes;
        self.secondStepper.value = self.currentRuntimeSeconds;
        
        [self updateRuntimeControls];
        
        [self.typeSelector setSelectedSegmentIndex:self.test.type];
    } else {
        self.navBar.title = @"New Test";
    }
    
    NSArray *colorSelectorSubviews = [self.channelSelector subviews];
    [[colorSelectorSubviews objectAtIndex:0] setTintColor:[UIColor redColor]];
    [[colorSelectorSubviews objectAtIndex:2] setTintColor:[UIColor greenColor]];
    [[colorSelectorSubviews objectAtIndex:1] setTintColor:[UIColor blueColor]];
}

- (IBAction)updateRuntime:(id)sender {
    /* hessk: mixing UI elements and processing here. volatile...? */
    if (self.currentRuntimeSeconds == [self.secondStepper maximumValue] && [self.secondStepper value] == [self.secondStepper minimumValue]) {
        // positive wrap must've occurred...
        self.minuteStepper.value++;
    }
    
    if (self.currentRuntimeSeconds == [self.secondStepper minimumValue] && [self.secondStepper value] == [self.secondStepper maximumValue]) {
        // negative wrap must've occurred...
        self.minuteStepper.value--;
    }
    
    self.currentRuntimeMinutes = [self.minuteStepper value];
    self.currentRuntimeSeconds = [self.secondStepper value];
    
    [self updateRuntimeControls];
}

- (void)updateRuntimeControls {
    self.minuteLabel.text = [[@(self.currentRuntimeMinutes) stringValue] stringByAppendingString:@" min"];
    self.secondLabel.text = [[@(self.currentRuntimeSeconds) stringValue] stringByAppendingString:@" sec"];
    
    // second stepper wrapping dictated by max and min values of minute stepper
    if ((self.currentRuntimeMinutes > [self.minuteStepper minimumValue] || self.currentRuntimeSeconds > [self.secondStepper minimumValue]) && (self.currentRuntimeMinutes < [self.minuteStepper maximumValue] || self.currentRuntimeSeconds < [self.secondStepper maximumValue])) {
        [self.secondStepper setWraps:YES];
    } else {
        [self.secondStepper setWraps:NO];
    }
}

- (IBAction)updateTitle:(id)sender {
    self.navBar.title = [(UITextField *)sender text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSTimeInterval runtime = self.currentRuntimeMinutes * 60 + self.currentRuntimeSeconds;
    
    // hessk: initialize a test if there isn't one already using the name in the text field
    // otherwise, just update the one that's there
    if (sender != self.deleteButton && self.nameField.text.length > 0) {
        if (!self.test) {
            self.test = [[JKKTest alloc] initWithName:self.nameField.text Runtime:runtime ModelType:(ModelType)self.typeSelector.selectedSegmentIndex];
        } else {
            [self.test setName:self.nameField.text];
            [self.test setType:(ModelType)self.typeSelector.selectedSegmentIndex];
            [self.test setRuntime:runtime];
        }
    }
    
    // hessk: pass pointers on
    if ([[segue identifier] isEqualToString:@"showCameraFromTest"]) {
        [[segue destinationViewController] setTest:self.test];
        [[segue destinationViewController] setTakingCalibrationPoint:YES];
    } else if ([[segue identifier] isEqualToString:@"showSetup"]) {
        [[segue destinationViewController] setTest:self.test];
    }
}

- (IBAction)unwindToTestView:(UIStoryboardSegue *)segue {
    /* hessk: add calibration data to model? */
}

/* hessk: hides the keyboard if the user touches anywhere other than the specified views
 by "resigning" them as "first responders" */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.nameField isFirstResponder] && [touch view] != self.nameField) {
        [self.nameField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

@end
