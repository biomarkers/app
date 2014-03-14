//
//  JKKConfigViewController.m
//  App
//
//  Created by Kevin on 2/10/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKConfigViewController.h"

/* display pixel density for a circle based on the fps settings and x, y configuration */

@interface JKKConfigViewController ()

@end

@implementation JKKConfigViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // hessk: TODO: populate location segmented control labels with camera location enumeration
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger fps = [defaults integerForKey:@"kFPS"];
    
    NSInteger cameraLocation = [defaults integerForKey:@"kCameraLocation"];
    
    ROIMode roiMode = (ROIMode)[defaults integerForKey:@"kROIMode"];
    NSInteger roiX = [defaults integerForKey:@"kROIX"];
    NSInteger roiY = [defaults integerForKey:@"kROIY"];
    NSInteger roiR = [defaults integerForKey:@"kROIR"];
    
    
    [self.roiModeSegControl setSelectedSegmentIndex:roiMode];
    [self.roiXField setText:[NSString stringWithFormat:@"%ld", (long)roiX]];
    [self.roiYField setText:[NSString stringWithFormat:@"%ld", (long)roiY]];
    [self.roiRField setText:[NSString stringWithFormat:@"%ld", (long)roiR]];
    
    if (roiMode == AUTOMATIC) {
        [self.roiXField setEnabled:NO];
        [self.roiYField setEnabled:NO];
        [self.roiRField setEnabled:NO];
    } else if (roiMode == MANUAL) {
        [self.roiXField setEnabled:YES];
        [self.roiYField setEnabled:YES];
        [self.roiRField setEnabled:YES];
    } else {
        NSLog(@"Undefined ROI mode.");
    }
    
    [self.locationSegControl setSelectedSegmentIndex:cameraLocation];
    [self.fpsStepper setValue:fps];
    [self updateGUI:self.fpsStepper];
    
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

- (IBAction)updateGUI:(id)sender {
    
    if (sender == self.fpsStepper) {
        [self.fpsLabel setText:[NSString stringWithFormat:@"%.0f", [self.fpsStepper value]]];
    } else if (sender == self.roiModeSegControl) {
        if ([self.roiModeSegControl selectedSegmentIndex] == 0) {
            [self.roiXField setEnabled:NO];
            [self.roiYField setEnabled:NO];
            [self.roiRField setEnabled:NO];
        } else if ([self.roiModeSegControl selectedSegmentIndex] == 1) {
            [self.roiXField setEnabled:YES];
            [self.roiYField setEnabled:YES];
            [self.roiRField setEnabled:YES];
        } else {
            NSLog(@"Undefined ROI mode.");
        }
    }
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:[self.locationSegControl selectedSegmentIndex] forKey:@"kCameraLocation"];
    [defaults setInteger:[self.fpsStepper value] forKey:@"kFPS"];
    
    [defaults setInteger:[self.roiModeSegControl selectedSegmentIndex] forKey:@"kROIMode"];
    [defaults setInteger:[[self.roiXField text] integerValue] forKey:@"kROIX"];
    [defaults setInteger:[[self.roiYField text] integerValue] forKey:@"kROIY"];
    [defaults setInteger:[[self.roiRField text] integerValue] forKey:@"kROIR"];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fpsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
