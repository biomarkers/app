//
//  JKKGraphViewController.m
//  App
//
//  Created by Kevin on 3/13/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKGraphViewController.h"
#import "JKKCalibrationListViewController.h"

@interface JKKGraphViewController ()

@end

@implementation JKKGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initPlot];
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.discardButton) {
        self.test.model->chuckCalibration(self.test.model->getGraphedCalibration());
        [[[segue destinationViewController] calibrationStatsTextView] setText:@""];
    }
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    self.hostView.allowPinchScaling = YES;
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.plotAreaFrame.borderLineStyle = nil;
    self.hostView.hostedGraph = graph;
    
    // 2 - Set graph title
    //NSString *title = @"Calibration Plot";
    //graph.title = title;
    
    // 3 - Create and set text style
    //CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    //titleStyle.color = [CPTColor whiteColor];
    //titleStyle.fontName = @"Helvetica-Bold";
    //titleStyle.fontSize = 16.0f;
    //graph.titleTextStyle = titleStyle;
    //graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    //graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // 2 - Create the three plots
    CPTScatterPlot *redPlot = [[CPTScatterPlot alloc] init];
    redPlot.dataSource = self;
    redPlot.identifier = @"RED";
    CPTColor *redColor = [CPTColor redColor];
    [graph addPlot:redPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *greenPlot = [[CPTScatterPlot alloc] init];
    greenPlot.dataSource = self;
    greenPlot.identifier = @"GREEN";
    CPTColor *greenColor = [CPTColor greenColor];
    [graph addPlot:greenPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *bluePlot = [[CPTScatterPlot alloc] init];
    bluePlot.dataSource = self;
    bluePlot.identifier = @"BLUE";
    CPTColor *blueColor = [CPTColor blueColor];
    [graph addPlot:bluePlot toPlotSpace:plotSpace];
    
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:redPlot, greenPlot, bluePlot, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *redLineStyle = [redPlot.dataLineStyle mutableCopy];
    redLineStyle.lineWidth = 2.5;
    redLineStyle.lineColor = redColor;
    redPlot.dataLineStyle = redLineStyle;
    CPTMutableLineStyle *redSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    redSymbolLineStyle.lineColor = redColor;
    CPTPlotSymbol *redSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    redSymbol.fill = [CPTFill fillWithColor:redColor];
    redSymbol.lineStyle = redSymbolLineStyle;
    redSymbol.size = CGSizeMake(6.0f, 6.0f);
    redPlot.plotSymbol = redSymbol;
    
    CPTMutableLineStyle *greenLineStyle = [greenPlot.dataLineStyle mutableCopy];
    greenLineStyle.lineWidth = 1.0;
    greenLineStyle.lineColor = greenColor;
    greenPlot.dataLineStyle = greenLineStyle;
    CPTMutableLineStyle *greenSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    greenSymbolLineStyle.lineColor = greenColor;
    CPTPlotSymbol *greenSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenSymbol.fill = [CPTFill fillWithColor:greenColor];
    greenSymbol.lineStyle = greenSymbolLineStyle;
    greenSymbol.size = CGSizeMake(6.0f, 6.0f);
    greenPlot.plotSymbol = greenSymbol;
    
    CPTMutableLineStyle *blueLineStyle = [bluePlot.dataLineStyle mutableCopy];
    blueLineStyle.lineWidth = 2.0;
    blueLineStyle.lineColor = blueColor;
    bluePlot.dataLineStyle = blueLineStyle;
    CPTMutableLineStyle *blueSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    blueSymbolLineStyle.lineColor = blueColor;
    CPTPlotSymbol *blueSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    blueSymbol.fill = [CPTFill fillWithColor:blueColor];
    blueSymbol.lineStyle = blueSymbolLineStyle;
    blueSymbol.size = CGSizeMake(6.0f, 6.0f);
    bluePlot.plotSymbol = blueSymbol;
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor grayColor];
    tickLineStyle.lineWidth = 1.0f;
    
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Time (s)";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    
    // hessk: change this stuff to match our data
    CGFloat runTime = self.test.model->getModelRunTime();
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:runTime];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:runTime];
    
    /*
    int i;
    for (i = 0; i < runTime; runTime > 20 ? (i += (runTime / 20)) : (i += 1)) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d", i] textStyle:x.labelTextStyle];
        CGFloat location = i * (350 / runTime);
        
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
     */
    
    int i;
    for (i = 0; i < runTime; i++) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d", i] textStyle:x.labelTextStyle];
        CGFloat location = i;
        
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Value";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 50;
    NSInteger minorIncrement = 25;
    
    CGFloat yMax = 255.0f;
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    // hessk:return number of points for this plot (red, green, or blue)
    return self.test.model->getModelRunTime();
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    // hessk: valueCount should be number of x values
    NSInteger valueCount = self.test.model->getModelRunTime();
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                return [NSNumber numberWithUnsignedInteger:index];
            }
            break;
            
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:@"RED"] == YES) {
                //hessk: return red plot y value for x index
                return [NSNumber numberWithFloat:self.test.model->getRed(index)];
            } else if ([plot.identifier isEqual:@"GREEN"] == YES) {
                //hessk: return green plot y value for x index
                return [NSNumber numberWithFloat:self.test.model->getGreen(index)];
            } else if ([plot.identifier isEqual:@"BLUE"] == YES) {
                //hessk: return blue plot y value for x index
                return [NSNumber numberWithFloat:self.test.model->getBlue(index)];
            }
            break;
    }
    
    return [NSDecimalNumber zero];
}

@end
