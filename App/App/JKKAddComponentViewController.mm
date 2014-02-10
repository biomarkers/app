//
//  JKKAddComponentViewController.m
//  App
//
//  Created by Kevin on 2/8/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKAddComponentViewController.h"

@interface JKKAddComponentViewController ()

@property NSInteger currentEndTimeMinutes;
@property NSInteger currentEndTimeSeconds;

@end

@implementation JKKAddComponentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.currentEndTimeMinutes = 0;
        self.currentEndTimeSeconds = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initializeControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeControls {
    NSArray *colorSelectorSubviews = [self.channelSelector subviews];
    [[colorSelectorSubviews objectAtIndex: ModelComponent::RED] setTintColor:[UIColor redColor]];
    [[self channelSelector] setTitle:@"Red" forSegmentAtIndex:ModelComponent::RED];
    
    [[colorSelectorSubviews objectAtIndex: ModelComponent::GREEN] setTintColor:[UIColor blueColor]];
    [[self channelSelector] setTitle:@"Green" forSegmentAtIndex:ModelComponent::GREEN];
    
    [[colorSelectorSubviews objectAtIndex: ModelComponent::BLUE] setTintColor:[UIColor greenColor]];
    [[self channelSelector] setTitle:@"Blue" forSegmentAtIndex:ModelComponent::BLUE];
    
    [[self typeSelector] setTitle:@"Point" forSegmentAtIndex:ModelComponent::POINT];
    [[self typeSelector] setTitle:@"Linear" forSegmentAtIndex:ModelComponent::LINEAR];
    [[self typeSelector] setTitle:@"Exponential" forSegmentAtIndex:ModelComponent::EXPONENTIAL];
}

- (IBAction)updateRuntime:(id)sender {
    /* hessk: mixing UI elements and processing here. volatile...? */
    if (self.currentEndTimeSeconds == [self.secondStepper maximumValue] && [self.secondStepper value] == [self.secondStepper minimumValue]) {
        // positive wrap must've occurred...
        self.minuteStepper.value++;
    }
    
    if (self.currentEndTimeSeconds == [self.secondStepper minimumValue] && [self.secondStepper value] == [self.secondStepper maximumValue]) {
        // negative wrap must've occurred...
        self.minuteStepper.value--;
    }
    
    self.currentEndTimeMinutes = [self.minuteStepper value];
    self.currentEndTimeSeconds = [self.secondStepper value];
    
    [self updateRuntimeControls];
}

- (void)updateRuntimeControls {
    self.minuteLabel.text = [[@(self.currentEndTimeMinutes) stringValue] stringByAppendingString:@" min"];
    self.secondLabel.text = [[@(self.currentEndTimeSeconds) stringValue] stringByAppendingString:@" sec"];
    
    self.startMinuteLabel.text = [[NSString stringWithFormat:@"%.0f", self.startMinuteStepper.value] stringByAppendingString:@" min"];
    self.startSecondLabel.text = [[NSString stringWithFormat:@"%.0f", self.startSecondStepper.value] stringByAppendingString:@" sec"];
    
    // second stepper wrapping dictated by max and min values of minute stepper
    if ((self.currentEndTimeMinutes > [self.minuteStepper minimumValue] || self.currentEndTimeSeconds > [self.secondStepper minimumValue]) && (self.currentEndTimeMinutes < [self.minuteStepper maximumValue] || self.currentEndTimeSeconds < [self.secondStepper maximumValue])) {
        [self.secondStepper setWraps:YES];
    } else {
        [self.secondStepper setWraps:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /* check to see if the user pressed done - if so, set this controllers model component object */
    if (sender != self.doneButton) return;
    
    NSTimeInterval endTime = self.currentEndTimeMinutes * 60 + self.currentEndTimeSeconds;
    NSTimeInterval startTime = self.startMinuteStepper.value * 60 + self.startSecondStepper.value;
    
    self.component = [[JKKComponent alloc] initWithVarType:(ModelComponent::VariableType)[self.channelSelector selectedSegmentIndex]
                                                         withModelType:(ModelComponent::ModelType)[self.typeSelector selectedSegmentIndex]
                                                         withStartTime:startTime
                                                         withEndTime:endTime];
}

@end
