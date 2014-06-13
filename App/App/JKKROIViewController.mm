//
//  JKKROIViewController.m
//  OccuChrome
//
//  Created by Kevin Hess on 4/23/14.
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

#import "JKKROIViewController.h"
#import "JKKCalibrationListViewController.h"

#import "BiomarkerImageProcessor.h"
#import "CircularSampleAreaDetector.h"

#define MAX_MANUAL_RADIUS 500
#define MIN_MANUAL_RADIUS 1

@interface JKKROIViewController ()

@property NSUserDefaults *defaults;

@property float minScale;

@end

BiomarkerImageProcessor roiProcessor;

bool autoCircleDetection = NO;

@implementation JKKROIViewController

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
    
    // hessk: AVFoundation camera setup
    self.captureManager = [JKKCaptureManager new];
    [self.captureManager initializeSession];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    // hessk: camera location setup
    CameraLocation location = (CameraLocation)[self.defaults integerForKey:@"kCameraLocation"];
    
    @try {
        switch (location) {
            case FRONT:
                [self.captureManager initializeDevice:YES];
                break;
            case BACK:
            default:
                [self.captureManager initializeDevice:NO];
                break;
        }
        
        roiProcessor.reset();
        
        [self.captureManager initializeVideoOutWithFPS:[self.defaults integerForKey:@"kFPS"] usingDelegate:self];
        [self.captureManager initializePreviewLayerUsingView:self.cameraView withLayer:self.captureVideoPreviewLayer];
        [self startProcessing];
    } @catch(NSException *exception) {
        UIAlertView* calibrationValueAlert = [[UIAlertView alloc] initWithTitle:[exception name] message:[exception reason] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        calibrationValueAlert.alertViewStyle = UIAlertViewStyleDefault;
        
        [calibrationValueAlert show];
    }
}

- (void)startProcessing {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.captureManager stopSession];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)modeSwitched:(id)sender {
    autoCircleDetection = [(UISwitch *)sender isOn];
}

- (IBAction)updateCirclePosition:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.cameraOverlayView];
    
    
    float max = MAX(self.scaleX, self.scaleY);
    float min = MIN(self.scaleX, self.scaleY);
    
    float offset = ((max - min) * location.x);
    
    self.x = (location.x / max) + offset;
    self.y = (location.y / max);
}

- (IBAction)updateCircleRadius:(UIPinchGestureRecognizer *)sender {
    float originalRadius = self.r;
    float newRadius = originalRadius * [sender scale];
    
    if (newRadius < MAX_MANUAL_RADIUS && newRadius > MIN_MANUAL_RADIUS) {
        self.r = newRadius;
    }
    
    [sender setScale:1];
}

#pragma mark - Protocol AVCaptureVideoDataOutputSampleBufferDelegate
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    UIImage *outputImage = [JKKCaptureManager imageFromSampleBuffer:sampleBuffer];
    
    /* reverse x and y to account for portrait/landscape discrepancy between camera view and preview view */
    self.scaleX = self.cameraOverlayView.frame.size.width / outputImage.size.height;
    self.scaleY = self.cameraOverlayView.frame.size.height / outputImage.size.width;

    if (autoCircleDetection) {
        CircularSampleAreaDetector detector;
        
        std::vector<cv::Vec3f> circles;
        @autoreleasepool {
            cv::Mat mat = [JKKCaptureManager cvMatFromUIImage:outputImage];
            circles = detector.detect(mat);
        }
        
        if (circles.size() > 0) {
            [self.cameraOverlayView setTintColor:[UIColor greenColor]];
            self.y = circles[0][0];
            self.x = outputImage.size.height - circles[0][1];
            self.r = circles[0][2];
        } else {
            [self.cameraOverlayView setTintColor:[UIColor whiteColor]];
        }
    } else {
        [self.cameraOverlayView setTintColor:[UIColor blueColor]];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.xLabel setText:[NSString stringWithFormat:@"x:%.0f", self.x]];
        [self.yLabel setText:[NSString stringWithFormat:@"y:%.0f", self.y]];
        [self.rLabel setText:[NSString stringWithFormat:@"r:%.0f", self.r]];
        
        [self.cameraOverlayView updateCircleWithCenterX:self.x centerY:self.y radius:self.r scaleX:self.scaleX scaleY:self.scaleY];
    });
    
    outputImage = nil;
}

@end
