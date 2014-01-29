//
//  JKKCameraViewController.m
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKCameraViewController.h"

#import "BiomarkerImageProcessor.h"
#import "RegressionFactory.h"

@interface JKKCameraViewController ()

@property BiomarkerImageProcessor processor;

//@property RegressionFactory factory;
//@property RegressionModel* model;
@property NSTimer* timer;

@property float timeElapsed;

@end

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
    [self setState: POSITIONING];
    
    if (!self.test) NSLog(@"No test loaded.");
    
    /* hessk: Regression model setup */
    
    /*
    self.factory.addNewComponent(ModelComponent::EXPONENTIAL, 1, 400, ModelComponent::HUE);
    self.model = self.factory.getCreatedModel();
    
    self.model->setIndices(3, 2, 1, 0, -1);
    */
    
    /* hessk: Timer setup */
    self.timeElapsed = 0.0;
    
    /* hessk: Camera setup */
    self.cvCamera = [[CvVideoCamera alloc] initWithParentView:self.cameraView];
    self.cvCamera.delegate = self;
    self.cvCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.cvCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.cvCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.cvCamera.defaultFPS = 30;
    self.cvCamera.grayscaleMode = NO;
    
    
    [self.cvCamera start];
    NSLog(@"Camera started");
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startProcessing:(id)sender {
    [self.cvCamera lockBalance];
    [self.cvCamera lockExposure];
    [self.cvCamera lockFocus];
    
    [self.startButton setEnabled:NO];
    [self.startButton setHidden:YES];
    [self.statusLabel setText:@"Running..."];
    [self setState:RUNNING];
    
    /* adds delay before calling endProcessing */
    [self performSelector:@selector(endProcessing) withObject:nil afterDelay:self.test.runtime];
    
    NSLog(@"Camera state set to RUNNING");
}

- (void)endProcessing {
    /* Camera shutdown */
    [self setState:DONE];
    [self.cvCamera stop];
    
    // hessk: why are these maintained?
    [self.cvCamera unlockBalance];
    [self.cvCamera unlockExposure];
    [self.cvCamera unlockFocus];
    
    /* Do stuff with processor results here */
    
    
    
    
    
    NSLog(@"Camera state set to DONE");
    [self.statusLabel setText:@"Done."];
    
    if ([self isTakingCalibrationPoint]) {
        [self performSegueWithIdentifier:@"returnToTestView" sender:self];
    } else /* if (there are results) */ {
        [self performSegueWithIdentifier:@"showResultsFromCamera" sender:self];
    }
}

#pragma mark - Protocol CvVideoCameraDelegate
#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image;
{
    /* Do stuff with the image */
    if ([self state] == RUNNING) {
        
        dispatch_sync(dispatch_get_main_queue(),
                      ^{
                          //NSInteger timeRemaining = self.test.runtime - self.timeElapsed;
                          self.timeElapsed = self.timeElapsed + (1.0 / (float)self.cvCamera.defaultFPS);
                          [self.progressBar setProgress:self.timeElapsed / self.test.runtime animated:YES];
                          
                          /*
                          // Do some OpenCV stuff with the image
                          cv::Mat image_copy;
                          cvtColor(image, image_copy, CV_BGRA2BGR);
                          
                          // invert image
                          bitwise_not(image_copy, image_copy);
                          cvtColor(image_copy, image, CV_BGR2BGRA);
                           */
                          
                          cv::Scalar rgb = self.processor.process(image);
                      });
    }
    
    /* when done processing, call getSamples() to get an array of vectors */
    
}
#endif

@end
