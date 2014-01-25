//
//  JKKCameraInputViewController.m
//  CameraControl
//
//  Created by Kevin on 11/14/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//

#import "JKKCameraInputViewController.h"

@interface JKKCameraInputViewController ()

@end

@implementation JKKCameraInputViewController

- (IBAction)unwindToCameraInput:(UIStoryboardSegue *)segue
{
    
}

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
    
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Welcome to OpenCV" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [alert show];
    */
    
	self.wbButton.tintColor = [UIColor blueColor];
    self.expButton.tintColor = [UIColor blueColor];
    self.focButton.tintColor = [UIColor blueColor];
    
    self.videoCamera = [[JKKCvVideoCamera alloc] initWithParentView:_imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    
    /*
    self.captureManager = [JKKCaptureManager new];
    [self.captureManager initializeSession];
    [self.captureManager initializeDevice];
    
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureManager.session];
    self.previewView.backgroundColor = [UIColor clearColor];
    UIView *view = self.previewView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [newCaptureVideoPreviewLayer setFrame:bounds];
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    [viewLayer addSublayer:newCaptureVideoPreviewLayer];
    self.captureVideoPreviewLayer = newCaptureVideoPreviewLayer;
    [self.captureManager.session startRunning];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wbPress:(id)sender {
    [self.videoCamera toggleWhiteBalance];
    
    if (self.wbButton.tintColor != [UIColor redColor])
        self.wbButton.tintColor = [UIColor redColor];
    else
        self.wbButton.tintColor = [UIColor blueColor];
    NSLog(@"WB Pressed");
}

- (IBAction)expPress:(id)sender {
    [self.videoCamera toggleExposure];
    
    if (self.expButton.tintColor != [UIColor redColor])
        self.expButton.tintColor = [UIColor redColor];
    else
        self.expButton.tintColor = [UIColor blueColor];
    NSLog(@"Exp Pressed");
}

- (IBAction)focPress:(id)sender {
    [self.videoCamera toggleFocus];
    
    if (self.focButton.tintColor != [UIColor redColor])
        self.focButton.tintColor = [UIColor redColor];
    else
        self.focButton.tintColor = [UIColor blueColor];
    NSLog(@"Focus Pressed");
}

/*
- (IBAction)takePicture:(id)sender {
    NSLog(@"Take Picture Pressed");
}
 */

- (IBAction)actionStart:(id)sender {
    [self.videoCamera start];
    NSLog(@"Start button pressed");
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    dispatch_sync( dispatch_get_main_queue(),
                  ^{
                      /*
                      // Do some OpenCV stuff with the image
                      Mat image_copy;
                      cvtColor(image, image_copy, CV_BGRA2BGR);
    
                      // invert image
                      bitwise_not(image_copy, image_copy);
                      cvtColor(image_copy, image, CV_BGR2BGRA);
                    */
                      cv::Scalar rgb = self.processor.process(image);
                      std::stringstream ss;
                      
                      ss << rgb;
                      
                      UIColor *newColor = [UIColor colorWithRed:rgb[2]/255.0 green:rgb[1]/255.0 blue:rgb[0]/255.0 alpha:rgb[3]/255.0];
                    
                      self.colorLabel.textColor = newColor;
                      self.colorLabel.text = [NSString stringWithCString:ss.str().c_str()];
                    });
}

#endif
@end
