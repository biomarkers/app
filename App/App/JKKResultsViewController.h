//
//  JKKResultsViewController.h
//  OccuChrome
//
//  Created by Kevin Hess on 1/26/14.
//  Copyright 2014 Kyle Cesare, Kevin Hess, Joe Runde
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
