//
//  JKKHomeViewController.h
//  App
//
//  Created by Kevin on 1/25/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JKKResultsViewController.h"
#import "JKKTestViewController.h"

#import "JKKResult.h"
#import "JKKTest.h"

@interface JKKHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/* hessk: consider making these weak connections - does this cause strong reference loop? */
@property (strong, nonatomic) IBOutlet UITableView *testsTable;
@property (strong, nonatomic) IBOutlet UITableView *historyTable;

@end
