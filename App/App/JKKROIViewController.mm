//
//  JKKROIViewController.m
//  App
//
//  Created by Kevin on 4/23/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKROIViewController.h"
#import "JKKCalibrationListViewController.h"

#import "BiomarkerImageProcessor.h"
#import "CircularSampleAreaDetector.h"

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
    
    // hessk: image processor setup
    roiProcessor.setCircleDetectionEnabled(true);
    
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
    
    self.x = location.x / self.minScale;
    self.y = location.y / self.minScale;
}

- (IBAction)updateCircleRadius:(UIPinchGestureRecognizer *)sender {
    float originalRadius = self.r;
    float newRadius = originalRadius * [sender scale];
    
    if (newRadius < 500 && newRadius > 1) {
        self.r = newRadius;
    }
    
    [sender setScale:1];
}

#pragma mark - Protocol AVCaptureVideoDataOutputSampleBufferDelegate
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    UIImage *outputImage = [JKKCaptureManager imageFromSampleBuffer:sampleBuffer];
    
    /* reverse x and y to account for portrait/landscape discrepancy between camera view and preview view */
    float scaleX = self.cameraOverlayView.frame.size.width / outputImage.size.height;
    float scaleY = self.cameraOverlayView.frame.size.height / outputImage.size.width;
    self.minScale = MIN(scaleX, scaleY);

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
            self.x = circles[0][1];
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
        
        [self.cameraOverlayView updateCircleWithCenterX:self.x centerY:self.y radius:self.r scaleX:self.minScale scaleY:self.minScale];
    });
    
    outputImage = nil;
}

@end