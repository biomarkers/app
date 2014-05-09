//
//  JKKGraphViewController.h
//  App
//
//  Created by Kevin on 3/13/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKModel.h"

#import "CorePlot-CocoaTouch.h"

@interface JKKGraphViewController : UIViewController <CPTPlotDataSource>

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *discardButton;

@property JKKModel* test;
@property (strong, nonatomic) NSMutableArray *plotArray;

@property BOOL pca;
@property int numCalibrationValues;

@property RegressionModel::RegressionType regressionType;

@end
