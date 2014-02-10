//
//  JKKTestViewController.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKTestViewController.h"
#import "JKKCameraViewController.h"
#import "JKKAddComponentViewController.h"

@interface JKKTestViewController ()

@property float calibrationValue;
@property int FPS;

@property NSMutableArray* componentItems;
@property NSMutableArray* calibrationItems;

@end

RegressionFactory factory;

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
    self.FPS = 30;
    
    [self.componentsTable setDataSource:self];
    [self.componentsTable setDelegate:self];
    
    self.componentItems = [[NSMutableArray alloc] init];
    self.calibrationItems = [[NSMutableArray alloc] init];
    
    [self populateControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* hessk: called initially to match interface to current JKKTest and do other UI config */
- (void)populateControls {
    if (!self.test) {
        self.navBar.title = @"New Test";
    } else {
        self.navBar.title = [self.test getModelName];
        self.nameField.text = [self.test getModelName];
    }
    
    // hessk: TODO: really awkward button fiddling here - find a better system
    if ([self isNewTest]) {
        [[self takeSampleButton] setEnabled:NO];
        
        if ([[self componentItems] count] > 0) {
            [[self addCalibrationButton] setEnabled:YES];
        } else {
            [[self addCalibrationButton] setEnabled:NO];
        }
        
        if ([self.calibrationItems count] > 0) {
            [self.addComponentButton setEnabled:NO];
        } else {
            [self.addComponentButton setEnabled:YES];
        }
    } else {
        [[self takeSampleButton] setEnabled:YES];
        [[self addCalibrationButton] setEnabled:NO];
        [[self addComponentButton] setEnabled:NO];
    }
    
    [self.calibrationValuesLabel setText:[NSString stringWithFormat:@"Cal. Values: %d", [self.calibrationItems count]]];
}

- (IBAction)updateTitle:(id)sender {
    self.navBar.title = [(UITextField *)sender text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // hessk: initialize a test if there isn't one already (TEMP: and you aren't just adding a component)
    if (!self.test && sender != self.addComponentButton) {
        NSLog(@"Creating a new model...");
        std::string* modelName;
        if (self.nameField.text.length > 0) {
            modelName = new std::string([self.nameField.text UTF8String]);
        } else {
            modelName = new std::string([@"No name" UTF8String]);
        }
        
        factory.createNew(*modelName, *modelName);
        
        JKKComponent* currentComponent;
        for (int i = 0; i < [self.componentItems count]; i++) {
            currentComponent = [self.componentItems objectAtIndex:i];
            factory.addNewComponent([currentComponent modelType], [currentComponent startTime], [currentComponent endTime], [currentComponent varType]);
        }
        
        self.test = [[JKKModel alloc] initWithModel:factory.getCreatedModel()];
        self.test.model->setIndices(3, 2, 1, 0, -1);
    }
    
    // hessk: pass pointers on
    if ([[segue identifier] isEqualToString:@"showCameraFromTest"]) {
        [[segue destinationViewController] setTest:self.test];
        [[segue destinationViewController] setCalibrationValue:self.calibrationValue];
        [[segue destinationViewController] setTakingCalibrationPoint:YES];
    } else if ([[segue identifier] isEqualToString:@"showSetup"]) {
        [[segue destinationViewController] setTest:self.test];
    }
}

- (IBAction)unwindToTestView:(UIStoryboardSegue *)segue {
    //hessk: TODO: this method is getting called twice from camera view - fix this
    UIViewController* sourceController = segue.sourceViewController;
    
    if ([sourceController isKindOfClass:[JKKAddComponentViewController class]]) {
        // Add new component to component items
        JKKAddComponentViewController* source = (JKKAddComponentViewController*)sourceController;
        JKKComponent* item = [source component];
        
        if (item != nil) {
            NSLog(@"Found item to add");
            [self.componentItems addObject:item];
            [self.componentsTable reloadData];
            // TODO: Add to component to model here?
        }
    } else if ([sourceController isKindOfClass:[JKKCameraViewController class]]) {
        JKKCameraViewController* source = (JKKCameraViewController*)sourceController;
        NSNumber* item = [NSNumber numberWithFloat:[source calibrationValue]];
        
        if (item != nil) {
            [self.calibrationItems addObject:item];
        }
    }
    
    [self populateControls];
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

- (IBAction)addCalibrationPoint:(id)sender {
    UIAlertView* calibrationValueAlert = [[UIAlertView alloc] initWithTitle:@"Calibration value" message:@"Please enter the value of this sample."  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    calibrationValueAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [calibrationValueAlert show];
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        NSLog(@"Calibration val entered: %@", [[alertView textFieldAtIndex:0] text]);
        [self setCalibrationValue:[[[alertView textFieldAtIndex:0] text] floatValue]];
        [self performSegueWithIdentifier:@"showCameraFromTest" sender:self];
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
    
    if (tableView == self.componentsTable) {
        return [self.componentItems count];
    } else {
        //error: either throw an error or give a default value
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if (tableView == self.componentsTable) {
        cellIdentifier = @"ComponentsPrototypeCell";
    } else {
        //error
    }
    
    // hessk: assign specified prototype cell to this cell and get appropriate object from array at the same index
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (tableView == self.componentsTable) {
        JKKComponent* componentItem = [self.componentItems objectAtIndex:indexPath.row];
         
        // hessk: Get references to the prototype cells subviews by their tags (defined in IB)
        // But using literals like this is awkward. Consider alternatives.
        UILabel* title = (UILabel *)[cell.contentView viewWithTag:20];
        UILabel* detail = (UILabel *)[cell.contentView viewWithTag:21];
        
        [title setText:[NSString stringWithFormat:@"%@ (%@)", [componentItem getModelTypeString], [componentItem getVarTypeString]]];
        [detail setText: [NSString stringWithFormat:@"%.0fs to %.0fs", [componentItem startTime], [componentItem endTime]]];
    } else {
        //error
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // hessk: react to row selection here
}

@end
