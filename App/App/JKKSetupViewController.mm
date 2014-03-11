//
//  JKKSetupViewController.m
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKSetupViewController.h"
#import "JKKHomeViewController.h"

#import "JKKDatabaseManager.h"

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
    
    if (self.test) {
        [self.navBar setTitle:[[self.test getModelName] stringByAppendingString:@" Setup"]];
    }
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
    // hessk: pass pointers on
    if ([[segue identifier] isEqualToString:@"showCameraFromSetup"]) {
        // initialize result data with information user enters here; subject, notes, etc
        JKKResult* newResult = [[JKKResult alloc] initNewResultWithName:[self.test getModelName]
                                                                subject:[self.subjectField text]
                                                                  notes:[self.notesField text]];
        
        self.result = newResult;
        
        [[segue destinationViewController] setTest:self.test];
        [[segue destinationViewController] setResult:self.result];
        [[segue destinationViewController] setTakingCalibrationPoint:NO];
    } else if ([[segue identifier] isEqualToString:@"deleteModelSegue"]) {
        DataStore p = [[JKKDatabaseManager sharedInstance] openDatabase];
        p.deleteModelEntry(self.test.model->GetModelName());
        p.close();
    }
}

- (IBAction)unwindToSetup:(id)sender {
    // Unwind to run the test again from the results screen
}

- (IBAction)deleteTestWithConfirmation:(id)sender {
    UIAlertView* deleteConfirmationAlert = [[UIAlertView alloc] initWithTitle:@"Delete model?" message:@"Are you sure you want to delete this model?"  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    deleteConfirmationAlert.alertViewStyle = UIAlertViewStyleDefault;
    [deleteConfirmationAlert show];
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self performSegueWithIdentifier:@"deleteModelSegue" sender:self];
    }
}

@end
