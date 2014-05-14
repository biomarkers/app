//
//  JKKResultsViewController.h
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//
#pragma once
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "JKKResult.h"

@interface JKKResultsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property JKKResult* result;

@property (strong, nonatomic) IBOutlet UILabel *testLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UITextView *statsTextView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property UIViewController* sourceView;

@end
