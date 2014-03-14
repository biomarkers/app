//
//  JKKNavigationController.m
//  App
//
//  Created by Kevin on 3/13/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKNavigationController.h"

@interface JKKNavigationController ()

@end

@implementation JKKNavigationController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

@end
