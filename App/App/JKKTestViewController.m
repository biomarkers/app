//
//  JKKTestViewController.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKTestViewController.h"

@interface JKKTestViewController ()

@end

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
    
    if (self.test != nil) {
        self.navBar.title = self.test.name;
        self.nameField.text = self.test.name;
    } else {
        self.navBar.title = @"New Test";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // hessk: initialize a test if there isn't one already using the name in the text field
    // otherwise, just update the one that's there
    if (sender == self.saveButton && self.nameField.text.length > 0) {
        if (!self.test) {
            self.test = [[JKKTest alloc] initWithName:self.nameField.text];
        } else {
            [self.test setName:self.nameField.text];
        }
    }
}


@end
