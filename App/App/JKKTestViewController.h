//
//  JKKTestViewController.h
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKTest.h"

@interface JKKTestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *equationField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property JKKTest* test;

@end
