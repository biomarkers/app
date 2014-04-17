//
//  JKKResultsViewController.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKResultsViewController.h"

#import "JKKHomeViewController.h"
#import "JKKCameraViewController.h"

#import "JKKDatabaseManager.h"

@interface JKKResultsViewController ()

@property MFMailComposeViewController *mailViewController;

- (void)populateControls;

@end

@implementation JKKResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //hessk: initialize view controller for sharing results through e-mail
        
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

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)populateControls {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    
    DataStore p = [[JKKDatabaseManager sharedInstance] openDatabase];
    ModelEntry model = p.findModelEntryByName([self.result.name UTF8String]);
    NSString *modelUnits = [NSString stringWithUTF8String:model.units.c_str()];
    
    self.testLabel.text = self.result.name;
    self.dateLabel.text = self.result.date;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f %@", self.result.value, modelUnits];
    self.subjectLabel.text = self.result.subject;
    self.notesTextView.text = self.result.notes;
}

- (IBAction)unwindToSource:(id)sender {
    // if they pressed the delete button, go through delete process for result
    
    DataStore p = [[JKKDatabaseManager sharedInstance] openDatabase];
    if (sender == self.deleteButton) {
        if (self.result.resultID != -1) p.deleteResultEntry(self.result.resultID);
    } else if (self.result.resultID == -1) {
        // write results to database
        //TODO: replace empty strings with exported data, exported message...
        ResultEntry entry(-1, [self.result.name UTF8String], [self.result.subject UTF8String], [self.result.subject UTF8String], [self.result.date UTF8String], self.result.value, "", "");
        p.insertResultEntry(entry);
    }
    p.close();
    
    // perform unwind segue back from the source
    if ([self.sourceView isKindOfClass:[JKKHomeViewController class]]) {
        [self performSegueWithIdentifier:@"unwindToHomeFromResults" sender:sender];
    } else if ([self.sourceView isKindOfClass:[JKKCameraViewController class]]) {
        [self performSegueWithIdentifier:@"unwindToSetupFromResults" sender:sender];
    }
}

- (IBAction)sendMail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        self.mailViewController = [[MFMailComposeViewController alloc] init];
        self.mailViewController.mailComposeDelegate = self;
        
        [self.mailViewController setSubject:@"test subject"];
        [self.mailViewController setMessageBody:@"test subject" isHTML:NO];
    } else {
        NSLog(@"Unable to send mail on this device");
    }
    
    if (self.mailViewController) {
        [self presentViewController:self.mailViewController animated:YES completion:nil];
    }
}

#pragma mark MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (result == MFMailComposeResultSent) {
        NSLog(@"Message sent");
    } else if (result == MFMailComposeResultFailed) {
        NSLog(@"Failed to send message");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
