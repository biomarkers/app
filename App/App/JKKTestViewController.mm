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
    
    [self.componentsTable setDataSource:self];
    [self.componentsTable setDelegate:self];
    
    [self.nameField setDelegate:self];
    [self.unitsField setDelegate:self];
    
    self.componentItems = [[NSMutableArray alloc] init];
    self.calibrationItems = [[NSMutableArray alloc] init];
    
    [self populateControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

// hessk: called initially to match interface to current JKKModel and do other UI config
- (void)populateControls {
    // hessk: TODO: really awkward button fiddling here - find a better system
    // hessk: interface manipulations must be done in the main queue (this allows setting of the "hidden" property)
    dispatch_async(dispatch_get_main_queue(), ^{
        // show components stuff
        [self.addComponentButton setHidden:NO];
        [self.componentsTable setHidden:NO];
        [self.componentsLabel setHidden:NO];
        
        if ([[self componentItems] count] > 0) {
            [[self nextButton] setEnabled:YES];
        } else {
            [[self nextButton] setEnabled:NO];
        }
    });
}

- (IBAction)updateTitle:(id)sender {
    self.navBar.title = [(UITextField *)sender text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // hessk: pass pointers on for calibration if a calibration is being run
    if ([[segue identifier] isEqualToString:@"showCalibrationList"]) {
        // hessk: initialize a test if there isn't one
        if (!self.test) {
            NSLog(@"Creating a new model...");
            std::string* modelName;
            if (self.nameField.text.length > 0) {
                modelName = new std::string([self.nameField.text UTF8String]);
            } else {
                modelName = new std::string([@"No name" UTF8String]);
            }
            
            NSString *modelUnits;
            if (self.unitsField.text.length > 0) {
                modelUnits = self.unitsField.text;
            } else {
#warning TODO: user should not be able to continue without entering units
                modelUnits = @"units";
            }
            
            factory.createNew(*modelName, *modelName);
            
            JKKComponent* currentComponent;
            for (int i = 0; i < [self.componentItems count]; i++) {
                currentComponent = [self.componentItems objectAtIndex:i];
                factory.addNewComponent([currentComponent modelType], [currentComponent startTime], [currentComponent endTime], [currentComponent varType]);
            }
            
            self.test = [[JKKModel alloc] initWithModel:factory.getCreatedModel() units:modelUnits];
            self.test.model->setIndices(3, 2, 1, 0, -1);
        }
        
        [[segue destinationViewController] setTest:self.test];
    }
}

- (IBAction)unwindToTestView:(UIStoryboardSegue *)segue {
    UIViewController* sourceController = segue.sourceViewController;
    
    if ([sourceController isKindOfClass:[JKKAddComponentViewController class]]) {
        // Add new component to component items
        JKKAddComponentViewController* source = (JKKAddComponentViewController*)sourceController;
        JKKComponent* item = [source component];
        
        if (item != nil) {
            NSLog(@"Adding component");
            [self.componentItems addObject:item];
            [self.componentsTable reloadData];
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
    } else if ([self.unitsField isFirstResponder] && [touch view] != self.unitsField) {
        [self.unitsField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
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

#pragma mark UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
