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

@interface JKKResultsViewController ()

- (void)populateControls;

@end

@implementation JKKResultsViewController

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

- (void)populateControls {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    
    self.testLabel.text = self.result.name;
    self.dateLabel.text = [formatter stringFromDate:self.result.date];
    self.valueLabel.text = [NSString stringWithFormat:@"%f", self.result.value];
    self.subjectLabel.text = self.result.subject;
    self.notesTextView.text = self.result.notes;
}

- (IBAction)unwindToSource:(id)sender {
    if ([self.sourceView isKindOfClass:[JKKHomeViewController class]]) {
        [self performSegueWithIdentifier:@"unwindToHomeFromResults" sender:sender];
    } else if ([self.sourceView isKindOfClass:[JKKCameraViewController class]]) {
        [self performSegueWithIdentifier:@"unwindToTestFromResults" sender:sender];
    }
}

@end