//
//  JKKHomeViewController.h
//  App
//
//  Created by Kevin on 1/25/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//
#pragma once
#import <UIKit/UIKit.h>

#import "JKKResultsViewController.h"
#import "JKKTestViewController.h"

#import "JKKResult.h"

#import "RegressionFactory.h"

@interface JKKHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *testsTable;
@property (strong, nonatomic) IBOutlet UITableView *historyTable;

@end
