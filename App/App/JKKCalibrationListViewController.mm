//
//  JKKCalibrationListViewController.m
//  App
//
//  Created by Kevin on 3/12/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKCalibrationListViewController.h"

#import "JKKCameraViewController.h"

@interface JKKCalibrationListViewController ()

@property float newCalibrationValue;
@property NSMutableArray* calibrationItems;

@end

@implementation JKKCalibrationListViewController

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
    
    [self.calibrationTable setDelegate:self];
    [self.calibrationTable setDataSource:self];
    self.calibrationItems = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showCameraForCalibration"]) {
        [[segue destinationViewController] setTest:self.test];
        [[segue destinationViewController] setCalibrationValue:self.newCalibrationValue];
        [[segue destinationViewController] setTakingCalibrationPoint:YES];
    } else if ([[segue identifier] isEqualToString:@"returnToTestFromCalibration"]) {
        //hessk: TODO: add warning that model data is going to be dropped
        [[segue destinationViewController] setTest:nil];
    }
}

- (IBAction)unwindToCalibrationList:(UIStoryboardSegue*)segue {
    [self updateControls];
}

#warning Incomplete method implementation
- (void)updateControls {
    // TODO: implement this
    [self.calibrationItems removeAllObjects];
    for (int i = 0; i < self.test.model->getNumCalibrations(); i++) {
        [self.calibrationItems addObject:[NSNumber numberWithFloat:self.test.model->getCalibrationConcentration(i)]];
    }
    
    [self.calibrationTable reloadData];
}

- (IBAction)addCalibrationPoint:(id)sender {
    UIAlertView* calibrationValueAlert = [[UIAlertView alloc] initWithTitle:@"Calibration value" message:@"Please enter the value of this sample."  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    calibrationValueAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [[calibrationValueAlert textFieldAtIndex:0] resignFirstResponder];
    [[calibrationValueAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
    [[calibrationValueAlert textFieldAtIndex:0] becomeFirstResponder];
    
    [calibrationValueAlert show];
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        NSLog(@"Calibration val entered: %@", [[alertView textFieldAtIndex:0] text]);
        [self setNewCalibrationValue:[[[alertView textFieldAtIndex:0] text] floatValue]];
        [self performSegueWithIdentifier:@"showCameraForCalibration" sender:self];
    }
}

#pragma mark UITableViewDelegate/DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.test.model->getNumCalibrations();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if (tableView == self.calibrationTable) {
        cellIdentifier = @"CalibrationPrototypeCell";
    } else {
        //error
    }
    
    // hessk: assign specified prototype cell to this cell and get appropriate object from array at the same index
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (tableView == self.calibrationTable) {
        NSNumber* calibrationPointValue = [self.calibrationItems objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%.2f", [calibrationPointValue floatValue]];
    } else {
        //error
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // hessk: react to row selection here
    self.test.model->setStatsForCalibration(indexPath.row);
    [self.calibrationStatsTextView setText:[NSString stringWithCString:self.test.model->getStatData().c_str() encoding:NSUTF8StringEncoding]];
    
}


@end
