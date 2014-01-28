//
//  JKKCameraViewController.m
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKCameraViewController.h"

#ifdef __cplusplus
@interface JKKCameraViewController ()

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
    
    /* hessk: Regression model setup */
    
    /*
    self.factory.addNewComponent(ModelComponent::EXPONENTIAL, 1, 400, ModelComponent::HUE);
    self.model = self.factory.getCreatedModel();
    
    self.model->setIndices(3, 2, 1, 0, -1);
    */
    
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
    
    NSLog(@"Camera state set to RUNNING");
}

#pragma mark - Protocol CvVideoCameraDelegate


- (void)processImage:(cv::Mat&)image;
{
    /* Do stuff with the image */
    if ([self state] == RUNNING) {
        dispatch_sync(dispatch_get_main_queue(),
                      ^{
                          // Do some OpenCV stuff with the image
                          cv::Mat image_copy;
                          cvtColor(image, image_copy, CV_BGRA2BGR);
                          
                          // invert image
                          bitwise_not(image_copy, image_copy);
                          cvtColor(image_copy, image, CV_BGR2BGRA);
                          
                          cv::Scalar rgb = self.processor.process(image);
                      });
    }
    
    /* when done processing, call getSamples() to get an array of vectors */
    
}
#endif

@end
