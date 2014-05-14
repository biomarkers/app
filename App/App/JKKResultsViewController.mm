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
#import "DataExporter.h"

@interface JKKResultsViewController ()

@property MFMailComposeViewController *mailViewController;
@property NSString *resultData;
@property NSString *resultText;

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
    DataStore p = [[JKKDatabaseManager sharedInstance] openDatabase];
    ModelEntry model = p.findModelEntryByName([self.result.name UTF8String]);
    ResultEntry resultEntry = p.findResultForIdWithExportdData(self.result.resultID);
    p.close();
    
    self.resultData = [NSString stringWithUTF8String:resultEntry.exportedData.c_str()];
    self.resultText = [NSString stringWithUTF8String:resultEntry.exportedMessage.c_str()];
    NSString *modelUnits = [NSString stringWithUTF8String:model.units.c_str()];
    
    self.testLabel.text = self.result.name;
    self.dateLabel.text = self.result.date;
    self.valueLabel.text = [NSString stringWithFormat:@"%.0f %@", roundf(self.result.value), modelUnits];
    self.subjectLabel.text = self.result.subject;
    self.notesTextView.text = self.result.notes;
}

- (IBAction)unwindToSource:(id)sender {
    // if they pressed the delete button, go through delete process for result

    if (sender == self.deleteButton) {
        DataStore p = [[JKKDatabaseManager sharedInstance] openDatabase];
        p.deleteResultEntry(self.result.resultID);
        p.close();
    }
    
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
        
        NSString *messageBody = [NSString stringWithFormat:@"Subject: %@\nNotes: %@\nModel: %@\n\n%@", self.result.subject, self.result.notes, self.result.name, self.resultText];
        
        [self.mailViewController setSubject:@"Diagnostic Results"];
        [self.mailViewController setMessageBody:messageBody isHTML:NO];
        [self.mailViewController addAttachmentData:[self.resultData dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/csv" fileName:@"results.csv"];
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
