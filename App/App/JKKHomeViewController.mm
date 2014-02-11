//
//  JKKHomeViewController.m
//  App
//
//  Created by Kevin on 1/25/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKHomeViewController.h"

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
    
    RegressionFactory::RegressionFactory factory;
    factory.createNew("Sample", "Sample");
    factory.addNewComponent(ModelComponent::LINEAR, 0, 326, ModelComponent::RED);
    factory.addNewComponent(ModelComponent::POINT, 293, 326, ModelComponent::RED);
    
    cv::Mat matrix(5, 3, CV_32F);
    matrix.row(0).at<float>(0) = 40;
    matrix.row(0).at<float>(1) = .00023632315 * 30;
    matrix.row(0).at<float>(2) = 235.61401;
    
    matrix.row(1).at<float>(0) = 100;
    matrix.row(1).at<float>(1) = -0.00077432749 * 30;
    matrix.row(1).at<float>(2) = 227.77617;
    
    matrix.row(2).at<float>(0) = 200;
    matrix.row(2).at<float>(1) = -0.00279011 * 30;
    matrix.row(2).at<float>(2) = 213.48505;
    
    matrix.row(3).at<float>(0) = 300;
    matrix.row(3).at<float>(1) = -0.0048780013 * 30;
    matrix.row(3).at<float>(2) = 189.93724;
    
    matrix.row(4).at<float>(0) = 400;
    matrix.row(4).at<float>(1) = -0.0069368137 * 30;
    matrix.row(4).at<float>(2) = 173.00835;
    
    JKKModel* sampleModel;
    sampleModel = [[JKKModel alloc] initWithModel: factory.getCreatedModel()];
    sampleModel.model->setIndices(3, 2, 1, 0, -1);
    sampleModel.model->superSecretCalibrationOverride(matrix);
    sampleModel.model->dryCalibrate();
    
    [self.testItems addObject:sampleModel];
    [self.testsTable reloadData];
    
    /* Placeholder objects
    JKKTest* test1 = [[JKKTest alloc] initWithName:@"Glucose test"];
    JKKResult* result1 = [[JKKResult alloc] initWithTest:test1];
    result1.value = @42;
    [self.testItems addObject:test1];
    [self.historyItems addObject:result1];
     */
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
        //JKKTest* testItem = [self.testItems objectAtIndex:indexPath.row];
        JKKModel* testItem = [self.testItems objectAtIndex:indexPath.row];
        cell.textLabel.text = [testItem getModelName];
        
        //RegressionModel::RegressionModel* testItem = (RegressionModel::RegressionModel *)CFBridgingRetain([self.testItems objectAtIndex:indexPath.row]);
        //cell.textLabel.text = [NSString stringWithCString: testItem->GetModelName().c_str()];
        
    } else if (tableView == self.historyTable) {
        /*
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"mm/dd/yyyy"];
        
        JKKResult* historyItem = [self.historyItems objectAtIndex:indexPath.row];
        
        // hessk: Get references to the prototype cells subviews by their tags (defined in IB)
        // But using literals like this is awkward. Consider alternatives.
        UILabel* title = (UILabel *)[cell.contentView viewWithTag:10];
        UILabel* subtitle = (UILabel *)[cell.contentView viewWithTag:11];
        
        title.text = historyItem.test.name;
        subtitle.text = [formatter stringFromDate:historyItem.date];
         */
    } else {
        //error
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // hessk: row was selected - do something here?
    
    if (tableView == self.testsTable) {

    } else if (tableView == self.historyTable) {

    } else {

    }
    
}

/* hessk: this method overrides the UIViewController implementation, which does nothing.
    This is called whenever the view controller 'segues'. */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showResults"]) {
        // hessk: pass on the selected history item to the history view controller instance
        NSIndexPath* selectedHistoryItemPath = [self.historyTable indexPathForSelectedRow];
        JKKResult* selectedResult = [self.historyItems objectAtIndex:selectedHistoryItemPath.row];
        
        [[segue destinationViewController] setResult:selectedResult];
    } else if ([[segue identifier] isEqualToString:@"showTest"]) {
        // hessk: pass on the selected test to the test view controller instance
        NSIndexPath* selectedTestItemPath = [self.testsTable indexPathForSelectedRow];
        JKKModel* selectedTest = [self.testItems objectAtIndex:selectedTestItemPath.row];
        
        [[segue destinationViewController] setTest:selectedTest];
        [[segue destinationViewController] setNewTest:NO];
    } else if ([[segue identifier] isEqualToString:@"showNewTest"]) {
        // new test setup
        [[segue destinationViewController] setTest:nil];
        [[segue destinationViewController] setNewTest:YES];
    }
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)segue {
    
    UIViewController* source = segue.sourceViewController;
    
    if ([source isKindOfClass:[JKKTestViewController class]]) {
        JKKTestViewController* testViewSource = (JKKTestViewController *)source;
        JKKModel* newTest = testViewSource.test;
        
        if (![self.testItems containsObject:newTest]) {
            [self.testItems addObject:newTest];
        }
        
        [self.testsTable reloadData];
    } /*else if ([source isKindOfClass:[JKKResultsViewController class]]) {
        JKKResultsViewController* resultsViewSource = (JKKResultsViewController *)source;
        JKKResult* newResult = resultsViewSource.result;
        
        if (![self.historyItems containsObject:newResult]) {
            [self.historyItems addObject:newResult];
        }
        
        [self.historyTable reloadData];
    }*/
}

@end