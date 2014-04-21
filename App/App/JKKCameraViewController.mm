//
//  JKKCameraViewController.m
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKCameraViewController.h"

#import "JKKResultsViewController.h"

#import "BiomarkerImageProcessor.h"
#import "DataExporter.h"
#import "DataStore.h"
#import "ResultEntry.h"
#import "JKKDatabaseManager.h"

@interface JKKCameraViewController ()


//@property RegressionFactory factory;
//@property RegressionModel* model;

@property float timeElapsed;
@property (strong, nonatomic) JKKCaptureManager* captureManager;

@property NSTimer* timer;
@property int timerCount;
@property AVAudioPlayer* alertSound;
@property NSDate* timerStartDate;

@property ROIMode roiMode;
@property int roiX;
@property int roiY;
@property int roiR;

@end

NSUserDefaults* defaults;
BiomarkerImageProcessor processor;
bool overlayScaled = NO;
UIImage* outputImage;

const float TIMER_STEP = 0.1;

@implementation JKKCameraViewController

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
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if (!self.test) NSLog(@"No test loaded.");

    [self setState: POSITIONING];
    
    // hessk: Timer setup
    self.timeElapsed = 0.0;
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:TIMER_STEP target:self selector:@selector(updateProgress:) userInfo:NULL repeats:YES];
    self.timerCount = 0;
    
    // hessk: AVFoundation camera setup
    self.captureManager = [JKKCaptureManager new];
    [self.captureManager initializeSession];
    
    // hessk: region of interest setup
    self.roiMode = (ROIMode)[defaults integerForKey:@"kROIMode"];
    self.roiX = [defaults integerForKey:@"kROIX"];
    self.roiY = [defaults integerForKey:@"kROIY"];
    self.roiR = [defaults integerForKey:@"kROIR"];
    
    if (self.roiMode == AUTOMATIC) {
        processor.setCircleDetectionEnabled(true);
    } else if (self.roiMode == MANUAL) {
        processor.setCircleDetectionEnabled(false);
        
        processor.setCircleCenterX(self.roiX);
        processor.setCircleCenterY(self.roiY);
        processor.setCircleRadius(self.roiR);
    }
    
    // hessk: camera location setup
    CameraLocation location = (CameraLocation)[defaults integerForKey:@"kCameraLocation"];
    switch (location) {
        case FRONT:
            [self.captureManager initializeDevice:YES];
            break;
        case BACK:
        default:
            [self.captureManager initializeDevice:NO];
            break;
    }
    
    [self.captureManager initializeVideoOutWithFPS:[defaults integerForKey:@"kFPS"] usingDelegate:self];
    [self.captureManager initializePreviewLayerUsingView:self.cameraView withLayer:self.captureVideoPreviewLayer];
    [self.captureManager startSession];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)startProcessing:(id)sender {
    if (self.timer != nil) {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }

    [self.captureManager toggleAutoExposure];
    [self.captureManager toggleAutoFocus];
    [self.captureManager toggleAutoWB];

    [self.startButton setEnabled:NO];
    [self.startButton setHidden:YES];
    [self setState:RUNNING];
    
    processor.reset();
    
    [self.statusLabel setText:@"Analyzing"];
    NSLog(@"Camera state set to RUNNING");
    
    // adds delay before calling endProcessing and sets the start date for the countdown label
    [self setTimerStartDate:[NSDate date]];
    [self performSelector:@selector(endProcessing) withObject:nil afterDelay: (self.test.model->getModelRunTime())];
}

- (void)updateProgress:(NSTimer *)timer {
    if ([self state] == RUNNING) {
        NSTimeInterval timeSinceStart = [[NSDate date] timeIntervalSinceDate:self.timerStartDate];
        NSTimeInterval timeLeft = self.test.model->getModelRunTime() - timeSinceStart;
        double minutesLeft = floor(timeLeft / 60);
        double secondsLeft = trunc(timeLeft - (minutesLeft * 60));
        
        [self.progressBar setProgress: (timeSinceStart / self.test.model->getModelRunTime()) animated:YES];
        [self.statusLabel setText:[NSString stringWithFormat:@"Analyzing [%02.0f:%02.0f]", minutesLeft, secondsLeft]];
        
        if (timeLeft <= 0.0) {
            NSLog(@"Camera state set to DONE");
            [self setState:DONE];
            
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)endProcessing {
    /* Camera shutdown */
    [self.captureManager stopSession];
    [self.captureManager setSession: nil];
    
    [self.statusLabel setText:@"Done."];

    /*
    // notification w/sound
    NSError* error;
#warning untested alert message
    NSURL *soundFile = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] URLForResource:@"Tock" withExtension:@"aiff"];
    self.alertSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:&error];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Analysis completed."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    
    [self.alertSound play];
    [alert show];
     */
    
    if ([self isTakingCalibrationPoint]) {
        self.test.model->calibrate(processor.getSamples(), self.calibrationValue);
        
        //[self performSegueWithIdentifier:@"returnToTestView" sender:self];
        [self performSegueWithIdentifier:@"showCalibrationResults" sender:self];
    } else /* if (there are results) */ {
        self.result.value = self.test.model->evaluate(processor.getSamples());
        
        [self performSegueWithIdentifier:@"showResultsFromCamera" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCalibrationResults"]) {
        [[segue destinationViewController] setTest:self.test];
    } else if ([[segue identifier] isEqualToString:@"showResultsFromCamera"]) {
        DataExporter exporter = DataExporter(self.test.model);
        exporter.exportDiagnosticRun();
        DataStore p = [[JKKDatabaseManager sharedInstance] openDatabase];
        // write results to database
        ResultEntry entry(-1, [self.result.name UTF8String], [self.result.subject UTF8String], [self.result.subject UTF8String], [self.result.date UTF8String], self.result.value, exporter.getCSVData(), exporter.getTextData());
        
        self.result.resultID = p.insertResultEntry(entry);
        p.close();
        
        [[segue destinationViewController] setResult:self.result];
        [[segue destinationViewController] setSourceView:self];
    }
}

#pragma mark UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.alertSound stop];
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
}

#pragma mark - Protocol AVCaptureVideoDataOutputSampleBufferDelegate
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    outputImage = [JKKCaptureManager imageFromSampleBuffer:sampleBuffer];
    
    /* reverse x and y to account for portrait/landscape discrepancy between camera view and preview view */
    float scaleX = self.cameraOverlayView.frame.size.width / outputImage.size.height;
    float scaleY = self.cameraOverlayView.frame.size.height / outputImage.size.width;
    
    @autoreleasepool {
        if ([self state] == RUNNING) {
            cv::Mat mat = [JKKCaptureManager cvMatFromUIImage:outputImage];
            cv::Scalar rgb = processor.process(mat);
            
            std::stringstream ss;
            ss << rgb;
            NSLog([NSString stringWithCString:ss.str().c_str()]);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cameraOverlayView updateCircleWithCenterX:processor.getCircleCenterY() centerY:processor.getCircleCenterX() radius:processor.getCircleRadius() scaleX:scaleX scaleY:scaleY];
    });
    
    outputImage = nil;
}

@end
