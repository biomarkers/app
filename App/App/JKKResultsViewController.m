//
//  JKKResultsViewController.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKResultsViewController.h"

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
    // hessk: needs to be released...?
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm/dd/yyyy"];
    
    self.testLabel.text = self.result.test.name;
    self.dateLabel.text = [formatter stringFromDate:self.result.date];
    self.valueLabel.text = [self.result.value stringValue];
}

@end
