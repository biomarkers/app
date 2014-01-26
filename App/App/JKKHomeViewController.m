//
//  JKKHomeViewController.m
//  App
//
//  Created by Kevin on 1/25/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKHomeViewController.h"
#import "JKKResult.h"
#import "JKKTest.h"

@interface JKKHomeViewController ()

@property NSMutableArray* testItems;
@property NSMutableArray* historyItems;

@end

@implementation JKKHomeViewController

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
    
    [self.testsTable setDataSource:self];
    [self.testsTable setDelegate:self];
    [self.historyTable setDataSource:self];
    [self.historyTable setDelegate:self];
    
    
    // hessk: TODO: only adding sample items here; update to actually pull from core data
    
    self.historyItems = [[NSMutableArray alloc] init];
    self.testItems = [[NSMutableArray alloc] init];
    
    JKKTest* test1 = [[JKKTest alloc] initWithName:@"Glucose test"];
    JKKResult* result1 = [[JKKResult alloc] initWithTest:test1];
    
    [self.testItems addObject:test1];
    [self.historyItems addObject:result1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate/UITableViewDataSource protocol methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // hessk: this will be the number of items pulled from the Core Data objects
    
    if (tableView == self.testsTable) {
        //return the number of items in the test table
        return [self.testItems count];
    } else if (tableView == self.historyTable) {
        //return the number of items in the history table
        return [self.historyItems count];
    } else {
        //error: either throw an error or give a default value
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if (tableView == self.testsTable) {
        cellIdentifier = @"TestsPrototypeCell";
    } else if (tableView == self.historyTable) {
        cellIdentifier = @"HistoryPrototypeCell";
    } else {
        //error
    }
    
    // hessk: assign specified prototype cell to this cell and get appropriate object from array at the same index
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (tableView == self.testsTable) {
        
        JKKTest* testItem = [self.testItems objectAtIndex:indexPath.row];
        cell.textLabel.text = testItem.name;
        
    } else if (tableView == self.historyTable) {

        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@" mm/dd/yyyy"];
        
        JKKResult* historyItem = [self.historyItems objectAtIndex:indexPath.row];
        cell.textLabel.text = [historyItem.test.name stringByAppendingString:[formatter stringFromDate:historyItem.date]];

    } else {
        //error
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // hessk: row was selected - do something here
    
    if (tableView == self.testsTable) {

    } else if (tableView == self.historyTable) {

    } else {

    }
    
}

@end
