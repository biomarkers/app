//
//  JKKSetupViewController.h
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKTest.h"
#import "JKKCameraViewController.h"

@interface JKKSetupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *subjectField;
@property (strong, nonatomic) IBOutlet UITextView *notesField;
@property JKKTest* test;

@end
